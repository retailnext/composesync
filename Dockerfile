FROM golang:1.21@sha256:5f5d61dcb58900bc57b230431b6367c900f9982b583adcabf9fa93fd0aa5544a as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composesync -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regsync:edge-alpine@sha256:c629fdc918da186471f3777ceff817fc54e5849bc9aa4a77bdda479d47c5835c

COPY --from=build /go/bin/composesync /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composesync"]
