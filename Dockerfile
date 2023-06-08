FROM golang:1.20@sha256:4b1fc02d16fca272e5e6e6adc98396219b43ef663a377eef4a97e881d364393f as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composesync -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regsync:edge-alpine@sha256:69327352b73f5aa6c6863b3384e14938776598c7c5628f60225f5d87a6306dc7

COPY --from=build /go/bin/composesync /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composesync"]
