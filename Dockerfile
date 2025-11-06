#syntax=docker/dockerfile:1.19.0-labs@sha256:dce1c693ef318bca08c964ba3122ae6248e45a1b96d65c4563c8dc6fe80349a2

FROM golang:1.25.4@sha256:5d73b7b83dd6e0258ff62832c93b6ea208fbb7727985d265fb49f75f81fc3d1f AS build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY --parents ./compose ./regsync ./main.go ./

RUN CGO_ENABLED=0 go build -o /go/bin/composesync -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regsync:alpine@sha256:f74c370d763ec6d0f660185745440a5d4419aa1bda413c803493b2226321d5df

COPY --from=build /go/bin/composesync /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composesync"]
