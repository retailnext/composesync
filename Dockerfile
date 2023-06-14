FROM golang:1.20@sha256:f28300f5f485a115156f1de0e56e81ba3785e164d66f1d029fe745a7836e944b as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composesync -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regsync:edge-alpine@sha256:581a0f40f76475a51e2fcb3331eced3af5a4b02647ce04c3cc1b5b8604f3bb98

COPY --from=build /go/bin/composesync /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composesync"]
