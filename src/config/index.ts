import { ConfigModule as _ } from '@nestjs/config';
import { appConfig } from './app.config';
import { databaseConfig } from './database.config';
import { serviceConfig } from './service.conifg';

export * from './app.config';
export * from './database.config';
export * from './service.conifg';

export const ConfigModule = _.forRoot({
  cache: true,
  isGlobal: true,
  envFilePath: '.env',
  expandVariables: true,
  load: [appConfig, databaseConfig, serviceConfig],
});
