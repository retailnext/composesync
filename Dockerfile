FROM golang:1.21@sha256:8826f3bc393b250cd221fc6bd940c714c6da8a5517a0466019ad177a0e6cd953 as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composesync -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regsync:edge-alpine@sha256:34352644c7812bf457ee322312f0dd895c332557f8fb6356776d509b60d36b77

COPY --from=build /go/bin/composesync /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composesync"]
