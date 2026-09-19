#syntax=docker/dockerfile:1.27.0-labs@sha256:ae9cc40df4eb5b6adcac0a49bdd8e43b6d29d81087fefae2ceb6fe248aab24c8

FROM golang:1.27.1@sha256:1cfcdb11f37fce9429f617100f39e0251748bbaba454bd431275155701765058 AS build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY --parents ./compose ./regsync ./main.go ./

RUN CGO_ENABLED=0 go build -o /go/bin/composesync -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regsync:alpine@sha256:d27b054935126029e08518b774af477cb88181dd03938fb54c0a1b98110bf560

COPY --from=build /go/bin/composesync /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composesync"]
