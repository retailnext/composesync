#syntax=docker/dockerfile:1.25.0-labs@sha256:4426b5e269e36911b94fb79cf67f1fd7155ef11b2bbc8ab23cbfcbc97130efe9

FROM golang:1.26.5@sha256:3aff6657219a4d9c14e27fb1d8976c49c29fddb70ba835014f477e1c70636647 AS build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY --parents ./compose ./regsync ./main.go ./

RUN CGO_ENABLED=0 go build -o /go/bin/composesync -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regsync:alpine@sha256:2f34681e6d163cde0f60f6dd6bc8781326878a747c131b246dbcb9e5d62709b4

COPY --from=build /go/bin/composesync /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composesync"]
