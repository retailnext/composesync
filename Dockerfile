FROM golang:1.24@sha256:fa145a3c13f145356057e00ed6f66fbd9bf017798c9d7b2b8e956651fe4f52da as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composesync -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regsync:alpine@sha256:11b80d3236b1ccca70590cea73b7075d513da57af8ab434dfe16ef6850304fcd

COPY --from=build /go/bin/composesync /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composesync"]
