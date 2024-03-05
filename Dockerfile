FROM golang:1.22@sha256:7b297d9abee021bab9046e492506b3c2da8a3722cbf301653186545ecc1e00bb as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composesync -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regsync:edge-alpine@sha256:3856c2d5498223bca244361380dc4536602f77e8ccdd7d5542da803596f3b210

COPY --from=build /go/bin/composesync /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composesync"]
