FROM golang:1.23-alpine AS builder
WORKDIR /usr/src/app
COPY go.mod go.sum .
RUN go mod download
COPY . .
RUN go build -o main .

FROM alpine AS release
WORKDIR /usr/src/app

COPY --from=builder /usr/src/app/main .
COPY --from=builder /usr/src/app/static ./static
COPY --from=builder /usr/src/app/templates ./templates
ENV PORT=8080
EXPOSE ${PORT}
ENTRYPOINT ["./main"]