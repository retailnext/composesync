FROM golang:1.21@sha256:5f8a183f0cbfb9bfdf3f40b12e1ed149216e47af88d8b620f3c1efb2bef9f0b0 as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composesync -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regsync:edge-alpine@sha256:c629fdc918da186471f3777ceff817fc54e5849bc9aa4a77bdda479d47c5835c

COPY --from=build /go/bin/composesync /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composesync"]
