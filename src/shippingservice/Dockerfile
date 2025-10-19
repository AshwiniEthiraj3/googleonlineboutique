FROM golang:1.23-alpine AS builder
WORKDIR /usr/src/app
COPY go.mod go.sum .

RUN go mod download
COPY . .
RUN go build -o main .

FROM alpine AS release
WORKDIR /usr/src/app
COPY --from=builder /usr/src/app/main .
ENV PORT=50051
ENV PROJECT_ID=test-project

EXPOSE ${PORT}
ENTRYPOINT ["./main"] 