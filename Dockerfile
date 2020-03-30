FROM node:latest

COPY ./index.js index.js
COPY ./package.json package.json

EXPOSE 3000

RUN npm install --production

CMD ["node", "index.js"]
