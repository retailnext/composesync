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

	"gopkg.in/yaml.v3"
)

// Load returns a Document ready for Sync items to be added.
// If r is not nil, it will be parsed and Hosts (auths) will be copied from it.
func Load(r io.Reader) (Document, error) {
	var result Document
	var err error
	if r != nil {
		dec := yaml.NewDecoder(r)
		err = dec.Decode(&result)
		result.Sync = nil
	}
	if err == nil {
		if result.Version > MaxSupportedConfigVersion || result.Version < 0 {
			err = ErrUnsupportedConfigVersion(result.Version)
		} else {
			result.Version = MaxSupportedConfigVersion
		}
	}
	if err != nil {
		return Document{}, err
	}
	return result, nil
}
