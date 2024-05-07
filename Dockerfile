FROM golang:1.22@sha256:d5302d40dc5fbbf38ec472d1848a9d2391a13f93293a6a5b0b87c99dc0eaa6ae as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composesync -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regsync:edge-alpine@sha256:efe8d1cacd452e748b9810ced03006bf5a9ba6cd5f2941ac9c1df14e7e178968

COPY --from=build /go/bin/composesync /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composesync"]
