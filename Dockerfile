FROM node:lts-alpine3.16

WORKDIR /usr/app
COPY . .
CMD ["node", "server.js"]
