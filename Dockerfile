FROM golang:1.21@sha256:672a2286da3ee7a854c3e0a56e0838918d0dbb1c18652992930293312de898a6 as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composesync -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regsync:edge-alpine@sha256:4135ac8b7c755cde1c36d664a5ae710c72107f7b8a41002b45d83f7f81e15a0d

COPY --from=build /go/bin/composesync /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composesync"]
