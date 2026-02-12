#syntax=docker/dockerfile:1.21.0-labs@sha256:2e681d22e86e738a057075f930b81b2ab8bc2a34cd16001484a7453cfa7a03fb

FROM golang:1.26.0@sha256:c83e68f3ebb6943a2904fa66348867d108119890a2c6a2e6f07b38d0eb6c25c5 AS build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY --parents ./compose ./regsync ./main.go ./

RUN CGO_ENABLED=0 go build -o /go/bin/composesync -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regsync:alpine@sha256:2a290d3d48fc378741a67757147699fee1828795bfdec52568adb2c7f85abc15

COPY --from=build /go/bin/composesync /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composesync"]
