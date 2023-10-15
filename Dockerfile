FROM golang:1.21@sha256:24a09375a6216764a3eda6a25490a88ac178b5fcb9511d59d0da5ebf9e496474 as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composesync -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regsync:edge-alpine@sha256:5abf47c3a7124721ab3a367b8396acb332deef55bbce54f991b8b6869f1aa012

COPY --from=build /go/bin/composesync /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composesync"]
