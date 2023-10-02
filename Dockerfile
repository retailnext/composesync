FROM golang:1.21@sha256:19600fdcae402165dcdab18cb9649540bde6be7274dedb5d205b2f84029fe909 as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composesync -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regsync:edge-alpine@sha256:d242f26e4383af36c60426b8b86e328f7b6405466f5ca4d339833fc3530b09a7

COPY --from=build /go/bin/composesync /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composesync"]
