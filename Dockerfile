FROM golang:1.21@sha256:3049cdf48ea2d2a0d9bb4621c0b22245c0e471fde2975416b58f4462c3b3de3a as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composesync -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regsync:edge-alpine@sha256:ec4ea941216f88665e8559429df7cb82d32df90ffa345ce81e78946fd55e0926

COPY --from=build /go/bin/composesync /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composesync"]
