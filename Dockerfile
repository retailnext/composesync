FROM golang:1.21@sha256:b6142cdce09363951b0e05f2e78eb77471c0670f50fe8475a4a3dedb40a5d61d as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composesync -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regsync:edge-alpine@sha256:b2e7106703f0bb2174c93f4ae4cbe1a5537f21c4d19ba6d5ae22303045cad22d

COPY --from=build /go/bin/composesync /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composesync"]
