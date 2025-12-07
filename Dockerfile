#syntax=docker/dockerfile:1.20.0-labs@sha256:dbcde2ebc4abc8bb5c3c499b9c9a6876842bf5da243951cd2697f921a7aeb6a9

FROM golang:1.24.5@sha256:ef5b4be1f94b36c90385abd9b6b4f201723ae28e71acacb76d00687333c17282 AS build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY --parents ./compose ./regsync ./main.go ./

RUN CGO_ENABLED=0 go build -o /go/bin/composesync -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regsync:alpine@sha256:2a290d3d48fc378741a67757147699fee1828795bfdec52568adb2c7f85abc15

COPY --from=build /go/bin/composesync /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composesync"]
