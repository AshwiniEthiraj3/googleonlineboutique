FROM golang:1.23-alpine AS builder
WORKDIR /usr
COPY go.mod go.sum .
RUN go mod download

COPY . .
RUN go build -o server .

FROM alpine AS release
WORKDIR /usr
COPY --from=builder /usr/server .
COPY --from=builder /usr/products.json .

ENV PORT=3550
EXPOSE ${PORT}

ENTRYPOINT ["./server"]