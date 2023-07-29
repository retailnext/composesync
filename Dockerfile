FROM golang:1.20@sha256:3952625c7e85474d49f070f5cb8eaa8a7a10672870b63a004645110c6e33162b as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composesync -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regsync:edge-alpine@sha256:591b3327520a9e2eb598be3c1ebfcc3a49f71de8dc0e9cb9b7e65856445485c4

COPY --from=build /go/bin/composesync /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composesync"]
