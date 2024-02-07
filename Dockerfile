FROM golang:1.22@sha256:ef61a20960397f4d44b0e729298bf02327ca94f1519239ddc6d91689615b1367 as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composesync -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regsync:edge-alpine@sha256:1d87e81dcdafedf7721674d402d149ce327cb07a8dc2d9f8b1e8b978256c72af

COPY --from=build /go/bin/composesync /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composesync"]
