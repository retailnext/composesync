FROM golang:1.22@sha256:695e2559491efb2cc266226501b128eb6b4923d388f55ec182e1d96f65955a2a as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composesync -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regsync:edge-alpine@sha256:300c7c2db0e2afcbb4f720aade9c59f98eb937a37890c44cd0dce7c5c936de14

COPY --from=build /go/bin/composesync /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composesync"]
