FROM golang:1.21@sha256:9baee0edab4139ae9b108fffabb8e2e98a67f0b259fd25283c2a084bd74fea0d as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composesync -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regsync:edge-alpine@sha256:0dbd06fc54493572414cc3be22154b127c7bc232aaa34134c37a56b66dd3a6cb

COPY --from=build /go/bin/composesync /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composesync"]
