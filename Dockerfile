FROM golang:1.22@sha256:d41acbf8cb231da1a32e69e798e73fc9ed86881788d90d10a7bf90f097f9317a as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composesync -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regsync:edge-alpine@sha256:090fbd35728ad1889171032e0b6809ad16bee406aa626db27d0c59199ccbaa68

COPY --from=build /go/bin/composesync /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composesync"]
