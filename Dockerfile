#syntax=docker/dockerfile:1.21.0-labs@sha256:2e681d22e86e738a057075f930b81b2ab8bc2a34cd16001484a7453cfa7a03fb

FROM golang:1.24.5@sha256:ef5b4be1f94b36c90385abd9b6b4f201723ae28e71acacb76d00687333c17282 AS build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY --parents ./compose ./regsync ./main.go ./

RUN CGO_ENABLED=0 go build -o /go/bin/composesync -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regsync:alpine@sha256:5846c252e956e577add8fbb885b5f8a332aca163a948bd42888546480a5f5cc2

COPY --from=build /go/bin/composesync /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composesync"]
