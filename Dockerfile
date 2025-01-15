FROM golang:1.23@sha256:585103a29aa6d4c98bbb45d2446e1fdf41441698bbdf707d1801f5708e479f04 as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composesync -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regsync:alpine@sha256:6c1fd656f8ddb7a07b735f89ae29717119b9ad22f85efa440e68d4b537063219

COPY --from=build /go/bin/composesync /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composesync"]
