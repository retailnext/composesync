FROM golang:1.20@sha256:7954299532c2a54dd5d68d81a34316d3a5d26029dd78bd40a11d001b9f79985d as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composesync -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regsync:edge-alpine@sha256:0ecdf0d265dcb7fff3ec82416b20df689fbd57dcc75c6ee10f38381b9b05061a

COPY --from=build /go/bin/composesync /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composesync"]
