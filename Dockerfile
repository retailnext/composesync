FROM golang:1.21@sha256:552f804cc20b1bb12d1241e6858a1537a4cf82c47cd168f8cbeeb6e900616492 as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composesync -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regsync:edge-alpine@sha256:1ff47c3587c3a091678d91621108c16c865d15b24cec3cae4a79dcf7724840e1

COPY --from=build /go/bin/composesync /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composesync"]
