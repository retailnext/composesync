FROM golang:1.24@sha256:58cf31c1b10858d5772475e4f86853a03e0e220cc6cfd60965053951a2563b5e as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composesync -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regsync:alpine@sha256:11b80d3236b1ccca70590cea73b7075d513da57af8ab434dfe16ef6850304fcd

COPY --from=build /go/bin/composesync /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composesync"]
