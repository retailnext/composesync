FROM golang:1.23@sha256:613a108a4a4b1dfb6923305db791a19d088f77632317cfc3446825c54fb862cd as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composesync -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regsync:edge-alpine@sha256:557fc339e88aca5f448d9533343a589453797d9fae4687a01b22e71e480cca8a

COPY --from=build /go/bin/composesync /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composesync"]
