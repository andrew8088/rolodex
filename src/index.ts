import * as Koa from "koa";

const app = new Koa();

app.use((ctx) => {
  console.log('ping - ' + new Date().toISOString());
  ctx.body = 'Hello Koa + Typescript';
});

app.listen(80);
