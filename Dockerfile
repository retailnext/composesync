FROM golang:1.21@sha256:a1a43979d6beb876313daf2c541948c6a0e558d4d4df0cba66b4a7f76277fece as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composesync -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regsync:edge-alpine@sha256:e1880981665a568e391cae5a11d45cf8f4f3ba717af4ae030068a00c3300d239

COPY --from=build /go/bin/composesync /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composesync"]
