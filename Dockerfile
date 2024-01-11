FROM golang:1.21@sha256:8c534891d1a78032d14ea78a42f012cf6f69508fd490bbffe0cce178f657e731 as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composesync -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regsync:edge-alpine@sha256:a678ce4b6168cc60c19cd042a022f10b3ca76237b669b5773dd03a09487ce39a

COPY --from=build /go/bin/composesync /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composesync"]
