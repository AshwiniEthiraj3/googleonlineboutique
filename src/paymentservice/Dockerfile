FROM node:20-bullseye AS builder
WORKDIR /usr/src/app 

COPY package*.json .
RUN npm ci 
#if production build use this ,this will exclude ddev dependencies
#RUN npm ci --only=production

COPY . .

FROM node:20-bullseye AS release
WORKDIR /usr/src/app

COPY --from=builder /usr/src/app/ .

ENV PORT=8086
EXPOSE ${PORT}

CMD ["node", "index.js"]

