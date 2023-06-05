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

package regsync

import (
	"context"
	"io"
	"os"
	"os/exec"

	"go.uber.org/multierr"
)

func (d Document) Run(ctx context.Context, output io.Writer, debug bool) (err error) {
	var configFile string
	configFile, err = d.saveAsTempfile("")
	if err != nil {
		return err
	}
	defer func() {
		multierr.AppendInto(&err, os.Remove(configFile))
	}()

	flags := []string{
		"--config",
		configFile,
	}
	if debug {
		flags = append(flags, "--verbosity", "debug")
	}
	flags = append(flags, "once")

	cmd := exec.CommandContext(ctx, "regsync", flags...)
	cmd.Stdout = output
	cmd.Stderr = output
	err = cmd.Run()
	return
}
