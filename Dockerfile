FROM golang:1.22@sha256:0f7691253e132744318ff4b02e0824fec9fa4f3b43b08afd1195599660d51521 as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composesync -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regsync:edge-alpine@sha256:f430783f10218a857e809e7e3ffff4e15619f9d8710cd7c2741e26cb5768261f

COPY --from=build /go/bin/composesync /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composesync"]
