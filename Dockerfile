FROM golang:1.24@sha256:86b4cff66e04d41821a17cea30c1031ed53e2635e2be99ae0b4a7d69336b5063 as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composesync -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regsync:alpine@sha256:4ccb7aef3f96f0c9c20bae25af9df579bef2ce87a03f6396ee932fd7b9bbcf27

COPY --from=build /go/bin/composesync /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composesync"]
