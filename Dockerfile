FROM golang:1.23@sha256:613a108a4a4b1dfb6923305db791a19d088f77632317cfc3446825c54fb862cd as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composesync -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regsync:edge-alpine@sha256:2e2977c272d3f796911a915bd3b6bbb9b09541fd1f507a50219aa5753352cf97

COPY --from=build /go/bin/composesync /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composesync"]
