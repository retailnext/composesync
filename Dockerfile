FROM golang:1.21@sha256:cffaba795c36f07e372c7191b35ceaae114d74c31c3763d442982e3a4df3b39e as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composesync -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regsync:edge-alpine@sha256:02c17866bfae95f9edbcb5499d630398af76b56672c7261e65fb4f6d21a547a1

COPY --from=build /go/bin/composesync /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composesync"]
