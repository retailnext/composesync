FROM golang:1.23@sha256:73f06be4578c9987ce560087e2e2ea6485fb605e3910542cadd8fa09fc5f3e31 as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composesync -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regsync:alpine@sha256:3501c66946752e7ad17199a4a8cc793cb1f7584df535e0e40892cbf94a4a0674

COPY --from=build /go/bin/composesync /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composesync"]
