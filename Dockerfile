FROM golang:1.20@sha256:7925d69936ae2d202f9b9267c56a480ac4c93c4a5c945e0254e64ad788463567 as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composesync -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regsync:edge-alpine@sha256:0ecdf0d265dcb7fff3ec82416b20df689fbd57dcc75c6ee10f38381b9b05061a

COPY --from=build /go/bin/composesync /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composesync"]
