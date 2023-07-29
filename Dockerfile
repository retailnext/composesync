FROM golang:1.20@sha256:3b676a75c193b51e98207659890851fbcf2b42132741772cf0c9dbc7f749070e as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composesync -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regsync:edge-alpine@sha256:591b3327520a9e2eb598be3c1ebfcc3a49f71de8dc0e9cb9b7e65856445485c4

COPY --from=build /go/bin/composesync /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composesync"]
