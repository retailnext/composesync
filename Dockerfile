FROM golang:1.21@sha256:19600fdcae402165dcdab18cb9649540bde6be7274dedb5d205b2f84029fe909 as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composesync -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regsync:edge-alpine@sha256:793507aa4a76767e5427c209bb34ec86ae2ff8a2440ea7299d8ee21ede32832f

COPY --from=build /go/bin/composesync /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composesync"]
