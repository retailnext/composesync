FROM golang:1.21@sha256:b113af1e8b06f06a18ad41a6b331646dff587d7a4cf740f4852d16c49ed8ad73 as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composesync -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regsync:edge-alpine@sha256:34352644c7812bf457ee322312f0dd895c332557f8fb6356776d509b60d36b77

COPY --from=build /go/bin/composesync /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composesync"]
