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
	"io"
	"os"

	"go.uber.org/multierr"
	"gopkg.in/yaml.v3"
)

func (d Document) PrintRegSyncConfig() error {
	return d.save(os.Stdout)
}

func (d Document) save(w io.Writer) error {
	return yaml.NewEncoder(w).Encode(d)
}

func (d Document) saveAsTempfile(dir string) (name string, err error) {
	var f *os.File
	f, err = os.CreateTemp(dir, "regsync-*.yaml")
	if err != nil {
		return
	}
	name = f.Name()
	err = d.save(f)
	err = multierr.Append(err, f.Close())
	return
}
