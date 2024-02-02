FROM golang:1.21@sha256:7b575fe0d9c2e01553b04d9de8ffea6d35ca3ab3380d2a8db2acc8f0f1519a53 as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composesync -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regsync:edge-alpine@sha256:cecbfe27a929ded2d487e5f3c26cdbe239d566b580a0cc139997f1ce3b02ae26

COPY --from=build /go/bin/composesync /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composesync"]
