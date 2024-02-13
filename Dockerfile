FROM golang:1.22@sha256:cefea7fa6852b85f0042ce9d4b883c7e0b03b2bcb25972372d59e4f7c4367c04 as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composesync -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regsync:edge-alpine@sha256:8007c490ae3e23a85f53aee65bb1a8ff0495f00eec39d79dab7fb978499858f2

COPY --from=build /go/bin/composesync /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composesync"]
