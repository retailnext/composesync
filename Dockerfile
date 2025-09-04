#syntax=docker/dockerfile:1.18.0-labs@sha256:79cdc14e1c220efb546ad14a8ebc816e3277cd72d27195ced5bebdd226dd1025

FROM golang:1.24.5@sha256:ef5b4be1f94b36c90385abd9b6b4f201723ae28e71acacb76d00687333c17282 AS build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY --parents ./compose ./regsync ./main.go ./

RUN CGO_ENABLED=0 go build -o /go/bin/composesync -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regsync:alpine@sha256:f74c370d763ec6d0f660185745440a5d4419aa1bda413c803493b2226321d5df

COPY --from=build /go/bin/composesync /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composesync"]
