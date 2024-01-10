FROM golang:1.21@sha256:7026fb72cfa9cc112e4d1bf4b35a15cac61a413d0252d06615808e7c987b33a7 as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composesync -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regsync:edge-alpine@sha256:77f62ea489a85f64b50041fee3a33e8db192d319c226bead54975c33550fd545

COPY --from=build /go/bin/composesync /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composesync"]
