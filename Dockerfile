FROM golang:1.21@sha256:e3669c57c750394adadbcc33528788b9ec142ccd433f8ff3407e52f21c68fd16 as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composesync -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regsync:edge-alpine@sha256:6d3c945b399f89da32204a677e87eb32f2112cf0cd50fc0a33ff0bdfef54a2d9

COPY --from=build /go/bin/composesync /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composesync"]
