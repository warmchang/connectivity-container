FROM golang:1.13.4-alpine3.10 as builder
WORKDIR /tmp
COPY main.go .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags="-s -w" -o connectivity .
# RUN cp /usr/bin/curl .

FROM alpine:3.10.3
WORKDIR /root/
EXPOSE 8028
RUN apk add --no-cache curl
COPY --from=builder /tmp/connectivity .
CMD ["./connectivity"]
