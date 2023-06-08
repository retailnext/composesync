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

package compose

import "testing"

func TestSplitRef(t *testing.T) {
	cases := map[string]struct {
		name           string
		tagFragment    string
		digestFragment string
	}{
		"docker.elastic.co/elasticsearch/elasticsearch:7.17.10@sha256:bc7ba1dc5067c5b3907b82c667a374cc987cd813501e1378ec74ccd1c577f787": {
			name:           "docker.elastic.co/elasticsearch/elasticsearch",
			tagFragment:    ":7.17.10",
			digestFragment: "@sha256:bc7ba1dc5067c5b3907b82c667a374cc987cd813501e1378ec74ccd1c577f787",
		},
		"jaegertracing/all-in-one@sha256:5d5c9d2d8c8cbb42f1db4aac1f1f8487bac63da6802004d0da8580fc0c7311a1": {
			name:           "jaegertracing/all-in-one",
			digestFragment: "@sha256:5d5c9d2d8c8cbb42f1db4aac1f1f8487bac63da6802004d0da8580fc0c7311a1",
		},
		"ubuntu:22.04": {
			name:        "ubuntu",
			tagFragment: ":22.04",
		},
	}

	for ref, expected := range cases {
		name, tagFragment, digestFragment := splitRef(ref)
		if expected.name != name {
			t.Errorf("%q: name: expected=%q result=%q", ref, expected.name, name)
			t.Fail()
		}
		if expected.tagFragment != tagFragment {
			t.Errorf("%q: tagFragment: expected=%q result=%q", ref, expected.tagFragment, tagFragment)
			t.Fail()
		}
		if expected.digestFragment != digestFragment {
			t.Errorf("%q: digestFragment: expected=%q result=%q", ref, expected.digestFragment, digestFragment)
			t.Fail()
		}
	}
}
