FROM golang:1.20@sha256:bc5f0b5e43282627279fe5262ae275fecb3d2eae3b33977a7fd200c7a760d6f1 as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composesync -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regsync:edge-alpine@sha256:f858281870b4db68432f318f576e1a8c9882bebba1423927fd7546620b98be4b

COPY --from=build /go/bin/composesync /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composesync"]
