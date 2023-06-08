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

import "strings"

func splitRef(ref string) (name, tagFragment, digestFragment string) {
	tagIdx := strings.IndexRune(ref, ':')
	digestIdx := strings.IndexRune(ref, '@')
	if digestIdx > 0 {
		if tagIdx <= 0 || tagIdx > digestIdx {
			// Has digest but no tag
			name = ref[:digestIdx]
			digestFragment = ref[digestIdx:]
		} else {
			// Has a tag and a digest
			name = ref[:tagIdx]
			tagFragment = ref[tagIdx:digestIdx]
			digestFragment = ref[digestIdx:]
		}
	} else if tagIdx > 0 {
		// Has a tag but no digest
		name = ref[:tagIdx]
		tagFragment = ref[tagIdx:]
	} else {
		// No tag or digest fragments
		name = ref
	}
	return
}
