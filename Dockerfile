FROM golang:1.22@sha256:87bbc3e8e2c7cb625d09ed4c3ae4663e3ba4e64c6e59797a7ec1e3da7d972f7b as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composesync -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regsync:edge-alpine@sha256:a741dbef45fae0f05db4981833a750fd8409a20dd1ca98eb50022430fd4b3b6d

COPY --from=build /go/bin/composesync /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composesync"]
