#syntax=docker/dockerfile:1.21.0-labs@sha256:2e681d22e86e738a057075f930b81b2ab8bc2a34cd16001484a7453cfa7a03fb

FROM golang:1.25.7@sha256:011d6e21edbc198b7aeb06d705f17bc1cc219e102c932156ad61db45005c5d31 AS build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY --parents ./compose ./regsync ./main.go ./

RUN CGO_ENABLED=0 go build -o /go/bin/composesync -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regsync:alpine@sha256:2a290d3d48fc378741a67757147699fee1828795bfdec52568adb2c7f85abc15

COPY --from=build /go/bin/composesync /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composesync"]
