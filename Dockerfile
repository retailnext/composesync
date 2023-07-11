FROM golang:1.20@sha256:924b197badf1d4ee109a6d89986121a9553ff670d31175d2843311e264e6c2c1 as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composesync -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regsync:edge-alpine@sha256:4d500728bdc9a1182bc42ed2e75de6f6396d26afa55aa3dfd8a0be3b5e0728be

COPY --from=build /go/bin/composesync /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composesync"]
