FROM node:latest

WORKDIR /app

COPY ./src src
COPY ./package.json package.json
COPY ./yarn.lock yarn.lock
COPY ./tsconfig.json tsconfig.json

EXPOSE 80

RUN yarn install
RUN npx tsc

CMD ["node", "dist/index.js"]
