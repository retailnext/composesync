#syntax=docker/dockerfile:1.26.0-labs@sha256:63e440b412b6acba117974e793b7e7f702e58ee65e044bdff1b8d388ee0d853b

FROM golang:1.26.5@sha256:2005724102f45917a63e9d092fc0e4ea56ea575048ce147caad5f5f61502c365 AS build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY --parents ./compose ./regsync ./main.go ./

RUN CGO_ENABLED=0 go build -o /go/bin/composesync -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regsync:alpine@sha256:2f34681e6d163cde0f60f6dd6bc8781326878a747c131b246dbcb9e5d62709b4

COPY --from=build /go/bin/composesync /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composesync"]
