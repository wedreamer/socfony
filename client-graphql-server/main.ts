import { Logger, ValidationPipe } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { NestFactory } from '@nestjs/core';
import { AppConfig } from './app.config';
import { AppModule } from './app.module';

async function bootstrap() {
  // create application
  const app = await NestFactory.create(AppModule);

  // get IoC logger
  const logger = app.get(Logger);

  app.useLogger(logger);
  app.useGlobalPipes(
    new ValidationPipe({
      transform: true,
    }),
  );

  const { port, endpoint } = app.get(ConfigService).get<AppConfig>('app');
  await app.listen(port);

  const listeningURL = await app.getUrl();

  logger.log(`Application HTTP listening ${listeningURL}`, 'Bootstrap');
  logger.log(
    `Application WebSocket listening ${listeningURL.replace('http', 'ws')}`,
    'Bootstrap',
  );
  if (endpoint !== '/') {
    logger.log(
      `Application HTTP endpoint ${listeningURL}${endpoint}`,
      'Bootstrap',
    );
  }
}

bootstrap();
