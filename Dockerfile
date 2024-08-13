FROM golang:1.22@sha256:305aae5c6d68e9c122246147f2fde17700d477c9062b6724c4d182abf6d3907e as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composesync -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regsync:edge-alpine@sha256:58ae06333d86df69b138f8490c1aaa083261e85ca5b783ec95e46548319fbb08

COPY --from=build /go/bin/composesync /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composesync"]
