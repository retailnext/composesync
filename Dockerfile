FROM golang:1.22@sha256:b1e05e2c918f52c59d39ce7d5844f73b2f4511f7734add8bb98c9ecdd4443365 as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composesync -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regsync:edge-alpine@sha256:9286f04d17c137638818a3f2ebbd5d34146adf09a3516b01d1112cfa4eeb8c3e

COPY --from=build /go/bin/composesync /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composesync"]
