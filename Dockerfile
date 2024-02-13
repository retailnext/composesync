FROM golang:1.22@sha256:00ae06c880f116b86c7524862ab5ac5c44ed4d3d4a8749df78d955f922595b25 as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composesync -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regsync:edge-alpine@sha256:8007c490ae3e23a85f53aee65bb1a8ff0495f00eec39d79dab7fb978499858f2

COPY --from=build /go/bin/composesync /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composesync"]
