FROM golang:1.22@sha256:800fde66644c2447abc2a085cbecdcb53d2e21234ec8e80be0c90fc011a93f4b as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composesync -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regsync:edge-alpine@sha256:5238f0a5cba89b0effeee9b8ca872d53f824dfe4e6b6480f18f04e9db48a0ac6

COPY --from=build /go/bin/composesync /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composesync"]
