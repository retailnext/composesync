FROM golang:1.22@sha256:4a3e85e88ca4edb571679a3e8b86aaef16ad65134d3aba68760741a850d69f41 as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composesync -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regsync:edge-alpine@sha256:8007c490ae3e23a85f53aee65bb1a8ff0495f00eec39d79dab7fb978499858f2

COPY --from=build /go/bin/composesync /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composesync"]
