FROM golang:1.21@sha256:2c2a2a1250bee062627a39cc78a4fc96cb84fe0c0f55f2d83249c70e1edbcd42 as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composesync -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regsync:edge-alpine@sha256:6d3c945b399f89da32204a677e87eb32f2112cf0cd50fc0a33ff0bdfef54a2d9

COPY --from=build /go/bin/composesync /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composesync"]
