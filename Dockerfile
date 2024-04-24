FROM golang:1.22@sha256:c54c7d60b3bf561264bd6ef1f88cb6c4b5ec60d5881caf998e75d3699a0d098b as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composesync -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regsync:edge-alpine@sha256:d19e5f1e35e7c1a3a4cf13427359c350e4b5eb5f28b743a289be30a39e719270

COPY --from=build /go/bin/composesync /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composesync"]
