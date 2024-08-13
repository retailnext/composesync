FROM golang:1.22@sha256:bb9d8c48543148d038e2d76ffcc12ee7c80d3cb0132b325c1983680ca04d320d as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composesync -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regsync:edge-alpine@sha256:58ae06333d86df69b138f8490c1aaa083261e85ca5b783ec95e46548319fbb08

COPY --from=build /go/bin/composesync /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composesync"]
