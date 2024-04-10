FROM golang:1.22@sha256:b994e2c814955c73b9f93df71fde626a5c8aade26eb0de6e721a92d59eed5b3a as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composesync -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regsync:edge-alpine@sha256:aedb26e9c9560bb29335e3ad8b8c71f928148d6cf05d84605399d05aa3d8ab6f

COPY --from=build /go/bin/composesync /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composesync"]
