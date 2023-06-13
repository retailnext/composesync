FROM golang:1.20@sha256:02d4d8887131f2fea51bb380835917bd605dc2af1ac4ff90012fdaecf87fe10c as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composesync -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regsync:edge-alpine@sha256:581a0f40f76475a51e2fcb3331eced3af5a4b02647ce04c3cc1b5b8604f3bb98

COPY --from=build /go/bin/composesync /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composesync"]
