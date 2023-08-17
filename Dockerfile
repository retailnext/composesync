FROM golang:1.21@sha256:88832d39d42727d432dd2a82c923dae7b0f43dd12d40314ccb52b1128594282a as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composesync -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regsync:edge-alpine@sha256:6d3c945b399f89da32204a677e87eb32f2112cf0cd50fc0a33ff0bdfef54a2d9

COPY --from=build /go/bin/composesync /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composesync"]
