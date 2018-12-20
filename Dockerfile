FROM golang:1.10.7-alpine3.8 as builder
WORKDIR /tmp
COPY main.go .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags="-s -w" -o connectivity-container .
# RUN cp /usr/bin/curl .

FROM alpine:3.8
WORKDIR /root/
EXPOSE 8028
RUN apk add --no-cache curl
COPY --from=builder /tmp/connectivity-container .
CMD ["./connectivity-container"]
