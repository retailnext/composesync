FROM golang:1.20@sha256:f90834cb1d1d286b8606f570e988e2d610f1371fd08ae348b62147ec1a7af88e as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composesync -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regsync:edge-alpine@sha256:8946dfb6aa44af4985701d0ad0fb740de7c500e6ae5c7a6300dbcb800a84a17c

COPY --from=build /go/bin/composesync /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composesync"]
