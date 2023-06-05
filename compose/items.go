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
	"io"
	"sort"
	"strings"

	"gopkg.in/yaml.v3"
)

type SyncItem struct {
	Source string
	Target string
}

type SyncItems []SyncItem

func (s SyncItems) Len() int      { return len(s) }
func (s SyncItems) Swap(i, j int) { s[i], s[j] = s[j], s[i] }
func (s SyncItems) Less(i, j int) bool {
	if s[i].Source == s[j].Source {
		return s[i].Target < s[j].Target
	}
	return s[i].Source < s[j].Source
}

func GetSyncItems(r io.Reader, targetRepos []string) (SyncItems, error) {
	d := yaml.NewDecoder(r)
	var result document
	err := d.Decode(&result)
	if err != nil {
		return nil, err
	}
	return result.makeItems(targetRepos), nil
}

func (d document) makeItems(targetRepos []string) SyncItems {
	result := make(SyncItems, 0, len(d.Services)*len(targetRepos))
	for _, svc := range d.Services {
		src, dest := svc.item()
		for _, targetRepo := range targetRepos {
			result = append(result, SyncItem{
				Source: src,
				Target: targetRepo + "/" + dest,
			})
		}
	}
	sort.Sort(result)
	return result
}

func splitRef(ref string) (name, tagAndOrDigest string) {
	var splitAt int = -1
	if tagIdx := strings.Index(ref, ":"); tagIdx > 0 {
		splitAt = tagIdx
	} else if digestIdx := strings.LastIndex(ref, "@"); digestIdx > 0 {
		splitAt = digestIdx
	}
	if splitAt >= 0 {
		return ref[:splitAt], ref[splitAt:]
	}
	return ref, ""
}

func dropHostname(ref string) string {
	ref = strings.TrimPrefix(ref, "docker.io/")
	ref = strings.TrimPrefix(ref, "library/")
	parts := strings.SplitN(ref, "/", 1)
	if len(parts) == 1 {
		return parts[0]
	}
	if strings.ContainsRune(parts[0], '.') {
		return parts[1]
	}
	return ref
}

func (s service) destNameWithoutTagOrDigest() string {
	var name string = s.SyncName
	if name == "" {
		name = s.Image
	}
	name = dropHostname(name)
	name, _ = splitRef(name)
	return name
}

func (s service) item() (src, dest string) {
	src = s.Image
	_, tagAndOrDigest := splitRef(src)
	dest = s.destNameWithoutTagOrDigest() + tagAndOrDigest
	return
}
