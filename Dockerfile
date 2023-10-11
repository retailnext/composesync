FROM golang:1.21@sha256:02d7116222536a5cf0fcf631f90b507758b669648e0f20186d2dc94a9b419a9b as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composesync -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regsync:edge-alpine@sha256:b2e7106703f0bb2174c93f4ae4cbe1a5537f21c4d19ba6d5ae22303045cad22d

COPY --from=build /go/bin/composesync /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composesync"]
