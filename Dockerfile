FROM golang:1.21@sha256:76aadd914a29a2ee7a6b0f3389bb2fdb87727291d688e1d972abe6c0fa6f2ee0 as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composesync -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regsync:edge-alpine@sha256:487e9dab730aa77b3dc6bb0125be3ada39cd8f494e8c4ff65ed208eb9955884b

COPY --from=build /go/bin/composesync /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composesync"]
