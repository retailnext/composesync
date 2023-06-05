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

import "fmt"

const MaxSupportedConfigVersion int = 1

type Document struct {
	Version int        `yaml:"version,omitempty"`
	Hosts   []Host     `yaml:"creds,omitempty"`
	Sync    []SyncItem `yaml:"sync,omitempty"`
}

type Host struct {
	Name       string `yaml:"registry"`
	CredHelper string `yaml:"credHelper"`
	RepoAuth   bool   `yaml:"repoAuth"`
}

type SyncItem struct {
	Source string `yaml:"source"`
	Target string `yaml:"target"`
	Type   string `yaml:"type"`
}

type ErrUnsupportedConfigVersion int

func (e ErrUnsupportedConfigVersion) Error() string {
	return fmt.Sprintf("unsupported regsync config version: %d", int(e))
}
