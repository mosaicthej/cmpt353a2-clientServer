FROM node:lts-alpine3.16

WORKDIR /usr/app
# Copy all files from current directory to /usr/app
COPY . .    
RUN apk update && apk add bash  
CMD ["node", "server.js"]
