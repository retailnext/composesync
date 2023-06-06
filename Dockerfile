FROM golang:1.20@sha256:4b1fc02d16fca272e5e6e6adc98396219b43ef663a377eef4a97e881d364393f as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composesync -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regsync:edge-alpine@sha256:8946dfb6aa44af4985701d0ad0fb740de7c500e6ae5c7a6300dbcb800a84a17c

COPY --from=build /go/bin/composesync /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composesync"]
