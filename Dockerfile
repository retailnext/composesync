#syntax=docker/dockerfile:1.22.0-labs@sha256:4c116b618ed48404d579b5467127b20986f2a6b29e4b9be2fee841f632db6a86

FROM golang:1.26.1@sha256:c7e98cc0fd4dfb71ee7465fee6c9a5f079163307e4bf141b336bb9dae00159a5 AS build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY --parents ./compose ./regsync ./main.go ./

RUN CGO_ENABLED=0 go build -o /go/bin/composesync -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regsync:alpine@sha256:5846c252e956e577add8fbb885b5f8a332aca163a948bd42888546480a5f5cc2

COPY --from=build /go/bin/composesync /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composesync"]
