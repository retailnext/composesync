FROM golang:1.21@sha256:8144f2d44d2262fa930b437200fc4ada624d8a0b9c83d688e2a6f545d097c45b as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composesync -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regsync:edge-alpine@sha256:1d87e81dcdafedf7721674d402d149ce327cb07a8dc2d9f8b1e8b978256c72af

COPY --from=build /go/bin/composesync /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composesync"]
