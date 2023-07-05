FROM golang:1.20@sha256:20ee7c8a2be2fb81580e4db1b036c7237a363bac2d0f6b773e7291370d588d7b as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composesync -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regsync:edge-alpine@sha256:4d500728bdc9a1182bc42ed2e75de6f6396d26afa55aa3dfd8a0be3b5e0728be

COPY --from=build /go/bin/composesync /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composesync"]
