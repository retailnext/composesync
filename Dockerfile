FROM golang:1.21@sha256:2270a408c4cb38f8459839082d89afa4a2870773c509adf7641e9558167d0030 as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composesync -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regsync:edge-alpine@sha256:20887dbad6d0b3483a248d7e50462c9234bf88872adcd90fbfb4f2947acec17c

COPY --from=build /go/bin/composesync /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composesync"]
