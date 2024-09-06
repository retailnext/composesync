FROM golang:1.23@sha256:80cf6f99a6af101a6aee07c806803e2f4332002853ed4db7a07f4d5243a53af7 as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composesync -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regsync:alpine@sha256:a9db2da8f07588ffafbe7bcd74f27fe40997b9ce3ab53c46f8780727ca4d705e

COPY --from=build /go/bin/composesync /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composesync"]
