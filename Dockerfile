FROM golang:1.21@sha256:6fed3dd0193aa853c4416f4116f2183d7009c071e1d38159fdd638d57db78f7b as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composesync -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regsync:edge-alpine@sha256:34f9c1cd3198abfc44284cff4bf067a52eef8096e77161df8c587d8a3c463e8b

COPY --from=build /go/bin/composesync /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composesync"]
