FROM golang:1.23@sha256:017ec6b8081a283be9a45726f55e6e2830a7d66f94dbc09c557ca4ca1e6f7333 as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composesync -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regsync:alpine@sha256:3501c66946752e7ad17199a4a8cc793cb1f7584df535e0e40892cbf94a4a0674

COPY --from=build /go/bin/composesync /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composesync"]
