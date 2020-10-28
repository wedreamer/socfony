import { Logger } from '@nestjs/common';
import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  await app.listen(3000);

  const logger = new Logger('bootstrap');
  logger.log(`App listen http://127.0.0.1:3000`);
}
bootstrap();
