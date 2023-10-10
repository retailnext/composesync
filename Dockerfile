FROM golang:1.21@sha256:4d5cf6cb9269c5867ccf86b8282897b7eb4764d9739b1a19d8cc68643bbc3f3c as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composesync -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regsync:edge-alpine@sha256:b2e7106703f0bb2174c93f4ae4cbe1a5537f21c4d19ba6d5ae22303045cad22d

COPY --from=build /go/bin/composesync /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composesync"]
