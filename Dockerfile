FROM node:lts-alpine3.16

WORKDIR /usr/app
# Copy all files from current directory to /usr/app
COPY . .    
CMD ["node", "server.js"]
