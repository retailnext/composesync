FROM golang:1.23@sha256:090de5ea61eab91f74240d30e5253160c333b34e94a3fea2991746d2e2169513 as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composesync -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regsync:alpine@sha256:a9db2da8f07588ffafbe7bcd74f27fe40997b9ce3ab53c46f8780727ca4d705e

COPY --from=build /go/bin/composesync /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composesync"]
