FROM golang:1.20@sha256:344193a70dc3588452ea39b4a1e465a8d3c91f788ae053f7ee168cebf18e0a50 as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composesync -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regsync:edge-alpine@sha256:0dfb383dc1f4b8ccb315e3b7e05b7254455604f4c3dc0f668f6a96942879cf9d

COPY --from=build /go/bin/composesync /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composesync"]
