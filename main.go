// Copyright 2023 RetailNext, Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package main

import (
	"context"
	"os"
	"os/signal"

	"github.com/alecthomas/kong"
	"github.com/retailnext/composesync/compose"
	"github.com/retailnext/composesync/regsync"
	"go.uber.org/multierr"
	"go.uber.org/zap"
	"go.uber.org/zap/zapcore"
)

var cli struct {
	DryRun           bool     `kong:"name='dry-run',help='Show what regsync would have been invoked with'"`
	RegsyncConfig    string   `kong:"name='regsync-config',help='Regsync config file with creds section'"`
	RegsyncDebug     bool     `kong:"name='regsync-debug',help='Run regsync with debug logging enabled'"`
	ComposeYaml      string   `kong:"required,arg,help='Docker Compose yaml containing services with images'"`
	DestinationRepos []string `kong:"required,arg,help='Destination docker repository'"`
}

func getItems() (result []regsync.SyncItem, err error) {
	var f *os.File
	f, err = os.Open(cli.ComposeYaml)
	if err != nil {
		return
	}
	defer multierr.AppendInvoke(&err, multierr.Close(f))
	var items compose.SyncItems
	items, err = compose.GetSyncItems(f, cli.DestinationRepos)
	if err != nil {
		return nil, err
	}
	result = make([]regsync.SyncItem, 0, len(items))
	for _, item := range items {
		result = append(result, regsync.SyncItem{
			Source: item.Source,
			Target: item.Target,
			Type:   "image",
		})
	}
	return
}

func getConfigTemplate() (doc regsync.Document, err error) {
	if cli.RegsyncConfig != "" {
		var f *os.File
		f, err = os.Open(cli.RegsyncConfig)
		if err != nil {
			return
		}
		doc, err = regsync.Load(f)
		err = multierr.Append(err, f.Close())
	} else {
		doc, err = regsync.Load(nil)
	}
	if err != nil {
		return regsync.Document{}, err
	}
	return
}

func makeConfig(items []regsync.SyncItem) (doc regsync.Document, err error) {
	doc, err = getConfigTemplate()
	if err != nil {
		return regsync.Document{}, err
	}
	doc.Sync = items
	return
}

func setupLogger() (stdout zapcore.WriteSyncer, logger *zap.Logger) {
	stdout = zapcore.Lock(os.Stdout)
	consoleEncoder := zapcore.NewConsoleEncoder(zap.NewDevelopmentEncoderConfig())
	core := zapcore.NewCore(consoleEncoder, stdout, zap.NewAtomicLevel())
	logger = zap.New(core)
	return
}

func main() {
	_ = kong.Parse(&cli)
	stdout, logger := setupLogger()
	defer func(logger *zap.Logger) {
		_ = logger.Sync()
	}(logger)
	ctx, stop := signal.NotifyContext(context.Background(), os.Interrupt)
	defer stop()
	items, err := getItems()
	if err != nil {
		logger.Fatal("failed to get items", zap.Error(err))
	}
	doc, err := makeConfig(items)
	if err != nil {
		logger.Fatal("failed to make regsync config", zap.Error(err))
	}
	if cli.DryRun {
		err = doc.PrintRegSyncConfig()
		if err != nil {
			logger.Fatal("failed to generate output of regsync config", zap.Error(err))
		}
		return
	}
	err = doc.Run(ctx, stdout, cli.RegsyncDebug)
	if err != nil {
		logger.Fatal("failed to execute regsync", zap.Error(err))
	}
}
