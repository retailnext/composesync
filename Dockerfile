FROM golang:1.21@sha256:a514244d1eef32a62f0cb81253a825ce63d40f0e15b3fc05f14a922da3329104 as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composesync -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regsync:edge-alpine@sha256:897f11233560a202487b801dcff233e76e45fed208ea75935615cb606dc67c6c

COPY --from=build /go/bin/composesync /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composesync"]
