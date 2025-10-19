# Stage 1: Builder
FROM node:20-bullseye AS builder

WORKDIR /usr/src/app

COPY package*.json ./
RUN apt-get update && apt-get install -y python3 make g++ && rm -rf /var/lib/apt/lists/*
RUN npm ci
COPY . .

# Stage 2: Release
FROM node:20-bullseye AS release
WORKDIR /usr/src/app
COPY --from=builder /usr/src/app ./
ENV NODE_ENV=production
ENV PORT=7000
EXPOSE ${PORT}
CMD ["node", "server.js"]
