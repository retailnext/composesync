FROM golang:1.22@sha256:a0679accac8685cc5389bd2298e045e570100940e6bdcca666a8ca7b32a1276c as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composesync -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regsync:edge-alpine@sha256:f430783f10218a857e809e7e3ffff4e15619f9d8710cd7c2741e26cb5768261f

COPY --from=build /go/bin/composesync /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composesync"]
