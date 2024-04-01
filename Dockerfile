FROM golang:1.22@sha256:0b55ab82ac2a54a6f8f85ec8b943b9e470c39e32c109b766bbc1b801f3fa8d3b as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composesync -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regsync:edge-alpine@sha256:a99c7acc982e00ebee20aa4025f09ec17fe74951dbd368b3340154c6c660e177

COPY --from=build /go/bin/composesync /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composesync"]
