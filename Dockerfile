FROM golang:1.20@sha256:010a0ffe47398a3646993df44906c065c526eabf309d01fb0cbc9a5696024a60 as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composesync -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regsync:edge-alpine@sha256:591b3327520a9e2eb598be3c1ebfcc3a49f71de8dc0e9cb9b7e65856445485c4

COPY --from=build /go/bin/composesync /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composesync"]
