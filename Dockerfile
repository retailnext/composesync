FROM golang:1.21@sha256:d2aad22fc6f1017aa568d980b15d0067a721c770be47b9dc62b11c33487fba64 as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composesync -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regsync:edge-alpine@sha256:43302bfcf1d57bed882495b0e3bf946b42570dc2dbe12201b57b54e63fcb4892

COPY --from=build /go/bin/composesync /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composesync"]
