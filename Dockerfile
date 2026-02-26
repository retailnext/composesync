#syntax=docker/dockerfile:1.21.0-labs@sha256:2e681d22e86e738a057075f930b81b2ab8bc2a34cd16001484a7453cfa7a03fb

FROM golang:1.26.0@sha256:9edf71320ef8a791c4c33ec79f90496d641f306a91fb112d3d060d5c1cee4e20 AS build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY --parents ./compose ./regsync ./main.go ./

RUN CGO_ENABLED=0 go build -o /go/bin/composesync -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regsync:alpine@sha256:5846c252e956e577add8fbb885b5f8a332aca163a948bd42888546480a5f5cc2

COPY --from=build /go/bin/composesync /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composesync"]
