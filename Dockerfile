FROM golang:1.21@sha256:62e5883c278354041360e26dd3ba8c62c8621743a2b4fd7f0f0caf00af45d15c as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composesync -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regsync:edge-alpine@sha256:e1880981665a568e391cae5a11d45cf8f4f3ba717af4ae030068a00c3300d239

COPY --from=build /go/bin/composesync /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composesync"]
