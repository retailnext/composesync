FROM golang:1.21@sha256:81cd210ae58a6529d832af2892db822b30d84f817a671b8e1c15cff0b271a3db as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composesync -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regsync:edge-alpine@sha256:ce99e82424f7be04f63b39c1809cc8c4db70471481680cac9d74436b1377b21d

COPY --from=build /go/bin/composesync /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composesync"]
