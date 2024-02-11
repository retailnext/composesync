FROM golang:1.22@sha256:ef61a20960397f4d44b0e729298bf02327ca94f1519239ddc6d91689615b1367 as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composesync -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regsync:edge-alpine@sha256:fb4e2242e887f9543825c9b4978c8308ba396f7eef8c1db3026dcdf276543bf4

COPY --from=build /go/bin/composesync /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composesync"]
