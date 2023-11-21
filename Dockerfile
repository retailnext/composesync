FROM golang:1.21@sha256:3bd80b1ac6df79b9ae76313048f59ef989ffcd7647a517de2c65db5c95934425 as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composesync -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regsync:edge-alpine@sha256:1ff47c3587c3a091678d91621108c16c865d15b24cec3cae4a79dcf7724840e1

COPY --from=build /go/bin/composesync /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composesync"]
