#!/bin/busybox sh
set -euo pipefail

# Make sure regsync can be invoked
regsync version

cat > /tmp/compose.yaml <<EOF
---
services:
  regctl:
    image: ghcr.io/regclient/regctl:edge-alpine
  service-name-does-not-matter:
    image: "gcr.io/distroless/python3-debian11:nonroot@sha256:cc7021d6bd5aae9cdd976ae4b185cc59d5792b18aa5e18345dbf9b34d6b3f5a0"
    x-composesync-name: "python3"
EOF

cat > /tmp/regsync.yaml <<EOF
---
creds:
  - registry: gcr.io
    repoAuth: true
    credHelper: docker-credential-gcr
  - registry: us-docker.pkg.dev
    repoAuth: true
    credHelper: docker-credential-gcr
EOF

composesync --dry-run \
--regsync-config /tmp/regsync.yaml \
/tmp/compose.yaml \
us-docker.pkg.dev/myproject/myrepo

echo "Image OK!"
