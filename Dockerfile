FROM node:latest

COPY ./index.js index.js
COPY ./package.json package.json

EXPOSE 80

RUN yarn install --production

CMD ["node", "index.js"]
