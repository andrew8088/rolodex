import * as Koa from "koa";
import * as Router from 'koa-router';
import * as cors from '@koa/cors';

console.log('starting...');
const app = new Koa();
const router = new Router();

router.get('/status', (ctx, next) => {
  console.log('GET /status');
  ctx.status = 200;
  ctx.body = JSON.stringify({ status: 200, uptime: process.uptime() });
});

app.use(cors());
app.use(router.routes());
app.use(router.allowedMethods());

app.use((ctx) => {
  console.log('ping - ' + new Date().toISOString());
  ctx.body = 'Hello Koa + Typescript';
});

console.log('listening on port 80...');
app.listen(80);
