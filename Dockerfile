FROM golang:1.21@sha256:382013f83069d3e1d267d04c6d233ea378e7ae9e79a973875e5c21e28aa29082 as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composesync -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regsync:edge-alpine@sha256:b9e1a13a719e2e166328a0fda49068190c0fcc18a94c95dd0f5b0e102c3d7077

COPY --from=build /go/bin/composesync /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composesync"]
