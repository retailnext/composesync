FROM golang:1.20@sha256:519184356f970849c5f58764014c13ce20c3a3cadc13be7b8d87269bc5554ccd as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composesync -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regsync:edge-alpine@sha256:c522870fecb89c0df1df50b89563539b04388444dce18dc4c0bdcb799dc95b91

COPY --from=build /go/bin/composesync /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composesync"]
