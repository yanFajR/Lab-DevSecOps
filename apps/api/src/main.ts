import 'reflect-metadata';
import * as apm from 'elastic-apm-node';
apm.start({
  serviceName: process.env.APM_SERVICE_NAME || 'api',
  serverUrl: process.env.APM_SERVER_URL || 'http://localhost:8200',
  environment: process.env.NODE_ENV || 'local',
  captureBody: 'all',
});

import { NestFactory } from '@nestjs/core';
import { AppModule } from './module';
import { ValidationPipe } from '@nestjs/common';
import { v4 as uuidv4 } from 'uuid';
import rateLimit from 'express-rate-limit';

async function bootstrap() {
  const app = await NestFactory.create(AppModule, { logger: ['log','error','warn'] });

  // Basic rate limiting (per-IP)
  app.use(rateLimit({ windowMs: 60_000, max: 100 }));

  // Correlation ID middleware
  app.use((req: any, res: any, next: any) => {
    const existing = req.headers['x-request-id'];
    const id = typeof existing === 'string' && existing.length ? existing : uuidv4();
    req.correlationId = id;
    res.setHeader('x-request-id', id);
    next();
  });

  // Input validation
  app.useGlobalPipes(new ValidationPipe({ whitelist: true, transform: true }));

  const port = process.env.PORT || 3000;
  await app.listen(port, '0.0.0.0');
  // eslint-disable-next-line no-console
  console.log(JSON.stringify({ msg: 'api_started', port }));
}
bootstrap();
