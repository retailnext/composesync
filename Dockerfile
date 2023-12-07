FROM golang:1.21@sha256:58e14a93348a3515c2becc54ebd35302128225169d166b7c6802451ab336c907 as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composesync -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regsync:edge-alpine@sha256:ad79f06a348dce0ba8ffe1fcd64b1b9f5970d5fa40a17b783596ca9ec85f7e2a

COPY --from=build /go/bin/composesync /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composesync"]
