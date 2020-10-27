FROM node:15-alpine3.12
RUN mkdir -p /usr/src/node_modules && chown -R node:node /usr/src
WORKDIR /usr/src
COPY package*.json ./
USER node
RUN npm install
COPY --chown=node:node . .
EXPOSE 3000
CMD [ "node", "app.js" ]