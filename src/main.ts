import { Logger, ValidationPipe } from '@nestjs/common';
import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';

/**
 * Create application bootstrap.
 */
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

  await app.listen(3000);

  const listeningURL = await app.getUrl();

  logger.log(`Application HTTP listening ${listeningURL}`, 'Bootstrap');
  logger.log(
    `Application WebSocket listening ${listeningURL.replace('http', 'ws')}`,
    'Bootstrap',
  );
}

// Application run.
bootstrap();
