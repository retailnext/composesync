FROM golang:1.20@sha256:cfc9d1b07b1ef4f7a4571f0b60a99646a92ef76adb7d9943f4cb7b606c6554e2 as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composesync -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regsync:edge-alpine@sha256:856beac82851591e9fae94505e850965ca58c96738241ee722803ab10fefab85

COPY --from=build /go/bin/composesync /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composesync"]
