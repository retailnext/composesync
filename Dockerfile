FROM golang:1.23@sha256:70031844b8c225351d0bb63e2c383f80db85d92ba894e3da7e13bcf80efa9a37 as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composesync -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regsync:alpine@sha256:6c1fd656f8ddb7a07b735f89ae29717119b9ad22f85efa440e68d4b537063219

COPY --from=build /go/bin/composesync /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composesync"]
