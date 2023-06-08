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

import (
	"reflect"
	"sort"
	"strings"
	"testing"
)

const testComposeFileData = `---
version: "3.7"
services:
  domain_yestag_nodigest_yescustom:
    image: "gcr.io/cloud-spanner-emulator/emulator:1.5.4"
    x-composesync-name: cloud-spanner-emulator
  domain_yestag_yesdigest_yescustom:
    image: "docker.elastic.co/elasticsearch/elasticsearch:7.17.10@sha256:bc7ba1dc5067c5b3907b82c667a374cc987cd813501e1378ec74ccd1c577f787"
    x-composesync-name: elasticsearch
  hub_notag_yesdigest_nocustom:
    image: "jaegertracing/all-in-one@sha256:5d5c9d2d8c8cbb42f1db4aac1f1f8487bac63da6802004d0da8580fc0c7311a1"
  hub_notag_yesdigest_yescustom:
    image: "localstack/localstack:2.0.2@sha256:2b4ec60261238bfc9573193380724ed4b9ee9fa0f39726275cd8feb48a254219"
    x-composesync-name: localstack
  explicitdomain_explicitlibrary_yestag_nodigest_nocustom:
    image: "docker.io/library/ubuntu:22.04"
`

var testExpectedTargetSuffixes = []string{
	"cloud-spanner-emulator:1.5.4",
	"elasticsearch:7.17.10",
	"jaegertracing/all-in-one",
	"localstack:2.0.2",
	"ubuntu:22.04",
}

var testTargetPrefixes = []string{
	"dkr-us-west1.pkg.dev",
	"docker.io/library",
}

func TestGetSyncItems(t *testing.T) {
	r := strings.NewReader(testComposeFileData)
	items, err := GetSyncItems(r, testTargetPrefixes)
	if err != nil {
		t.Fatal(err)
	}

	for _, pfx := range testTargetPrefixes {
		toTrim := pfx + "/"
		var seenSuffixes []string
		for _, item := range items {
			target := strings.TrimPrefix(item.Target, toTrim)
			if item.Target != target {
				seenSuffixes = append(seenSuffixes, target)
			}
		}
		sort.Strings(seenSuffixes)
		if !reflect.DeepEqual(seenSuffixes, testExpectedTargetSuffixes) {
			t.Fatalf("wrong targets: prefix=%q actual=%+v expected=%+v", pfx, seenSuffixes, testExpectedTargetSuffixes)
		}
	}
}
