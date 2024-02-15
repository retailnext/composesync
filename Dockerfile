FROM golang:1.22@sha256:7b297d9abee021bab9046e492506b3c2da8a3722cbf301653186545ecc1e00bb as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composesync -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regsync:edge-alpine@sha256:a75c074500c0aa924912780934dbf7ffcec14d728e884bc1e0f662a5cc531ca6

COPY --from=build /go/bin/composesync /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composesync"]
