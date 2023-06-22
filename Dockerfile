FROM golang:1.20@sha256:9d0422f7dc934f665111a8545e0531705efc9c7df8c34dd173f8ae5d80565d37 as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composesync -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regsync:edge-alpine@sha256:b276e259031c0ed1dd775edb2b921101fae56ade9b1e93b5e8b894f531aa36f0

COPY --from=build /go/bin/composesync /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composesync"]
