FROM golang:1.14 AS builder
WORKDIR /app
COPY . /app
ARG GOARCH=amd64
RUN \
    CGO_ENABLED=0 \
    GOOS=linux \
    GOPROXY=https://proxy.golang.org,direct \
    go build -ldflags "-s -w" -o main .

FROM gruebel/upx:latest as upx
COPY --from=builder /app/main /app/main.raw
# Compress the binary and copy it to final image
RUN upx --best --lzma --overlay=strip -o /app/main /app/main.raw

FROM scratch
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY contrib/etc/group contrib/etc/passwd /etc/
COPY --from=upx /app/main .
USER user
ENTRYPOINT ["/main"]
