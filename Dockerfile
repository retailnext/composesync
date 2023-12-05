FROM golang:1.21@sha256:58e14a93348a3515c2becc54ebd35302128225169d166b7c6802451ab336c907 as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composesync -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regsync:edge-alpine@sha256:0dbd06fc54493572414cc3be22154b127c7bc232aaa34134c37a56b66dd3a6cb

COPY --from=build /go/bin/composesync /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composesync"]
