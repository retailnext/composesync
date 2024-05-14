FROM golang:1.22@sha256:72e8f4d661b29c3974572ee8add5cf99985804a85cd5678b912c5b2a4002c56f as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composesync -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regsync:edge-alpine@sha256:090fbd35728ad1889171032e0b6809ad16bee406aa626db27d0c59199ccbaa68

COPY --from=build /go/bin/composesync /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composesync"]
