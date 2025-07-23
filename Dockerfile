#syntax=docker/dockerfile:1.17.1-labs@sha256:9187104f31e3a002a8a6a3209ea1f937fb7486c093cbbde1e14b0fa0d7e4f1b5

FROM golang:1.24.5@sha256:a3bb6cd5f068b34961d60dcd7fc51fb70df7b74b4aa89ac480fc38a6ccba265e AS build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY --parents ./compose ./regsync ./main.go ./

RUN CGO_ENABLED=0 go build -o /go/bin/composesync -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regsync:alpine@sha256:9ba6df5c9953c8d9d96cfe57cf04b9d417a7eaa6d263a03901d407039e9d5239

COPY --from=build /go/bin/composesync /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composesync"]
