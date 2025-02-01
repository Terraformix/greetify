FROM node:20.18-alpine3.20
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
USER node
CMD [ "node", "index.js" ]