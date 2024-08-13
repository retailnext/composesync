FROM golang:1.22@sha256:bb9d8c48543148d038e2d76ffcc12ee7c80d3cb0132b325c1983680ca04d320d as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composesync -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regsync:edge-alpine@sha256:a2a527ec1242b20ed08bb6c8db59a84c9c90a9b2a5f460291a110b5cbcb271e5

COPY --from=build /go/bin/composesync /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composesync"]
