FROM golang:1.21@sha256:ec457a2fcd235259273428a24e09900c496d0c52207266f96a330062a01e3622 as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composesync -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regsync:edge-alpine@sha256:3535b525990d5c643e5c8b31b3b095d6e6dd4f2ddcb52d9be5deeda3aab621a5

COPY --from=build /go/bin/composesync /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composesync"]
