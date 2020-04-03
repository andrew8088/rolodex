const Koa = require('koa');

const app = new Koa();

app.use(ctx => {
  console.log('ping - ' + new Date().toISOString());
  ctx.body = 'Hello Koa';
});

app.listen(80);
