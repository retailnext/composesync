FROM golang:1.24@sha256:14fd8a55e59a560704e5fc44970b301d00d344e45d6b914dda228e09f359a088 as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composesync -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regsync:alpine@sha256:9ba6df5c9953c8d9d96cfe57cf04b9d417a7eaa6d263a03901d407039e9d5239

COPY --from=build /go/bin/composesync /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composesync"]
