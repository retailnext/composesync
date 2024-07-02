FROM golang:1.22@sha256:c8736b8dbf2b12c98bb0eeed91eef58ecef52b8c2bd49b8044531e8d8d8d58e8 as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composesync -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regsync:edge-alpine@sha256:5238f0a5cba89b0effeee9b8ca872d53f824dfe4e6b6480f18f04e9db48a0ac6

COPY --from=build /go/bin/composesync /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composesync"]
