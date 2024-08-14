FROM golang:1.22@sha256:d5e49f92b9566b0ddfc59a0d9d85cd8a848e88c8dc40d97e29f306f07c3f8338 as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composesync -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regsync:edge-alpine@sha256:a2a527ec1242b20ed08bb6c8db59a84c9c90a9b2a5f460291a110b5cbcb271e5

COPY --from=build /go/bin/composesync /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composesync"]
