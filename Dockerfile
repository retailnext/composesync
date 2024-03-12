FROM golang:1.22@sha256:af65374fc66d5752364535f761408af0b7852d1223fe4af200033b12c958715b as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composesync -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regsync:edge-alpine@sha256:ace9ea232ac8e7a7c295c0ef4bc60ea2c3e6f9cb67d1e930fa8640ea865090b2

COPY --from=build /go/bin/composesync /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composesync"]
