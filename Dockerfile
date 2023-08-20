FROM golang:1.21@sha256:b490ae1f0ece153648dd3c5d25be59a63f966b5f9e1311245c947de4506981aa as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composesync -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regsync:edge-alpine@sha256:f2f606793f63800976cb832271a38ccf8f3bcfd762781f4cde582d6efc87d526

COPY --from=build /go/bin/composesync /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composesync"]
