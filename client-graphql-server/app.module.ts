import { Module } from '@nestjs/common';
import { GraphQLModule } from '@nestjs/graphql';
import { ConfigModule } from '~config';
import { AppContextService, CoreConfig, coreConfig, CoreModule } from '~core';
import { LoggerModule } from '~logger';
import { AppConfig, appConfig } from './app.config';
import { AuthModule } from './auth';
import { SecurityCodeModule } from './security-code';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      load: [appConfig],
    }),
    GraphQLModule.forRootAsync({
      imports: [CoreModule],
      inject: [coreConfig.KEY, appConfig.KEY, AppContextService],
      useFactory(
        coreConfig: CoreConfig,
        appConfig: AppConfig,
        appContextService: AppContextService,
      ) {
        return {
          autoSchemaFile: true,
          installSubscriptionHandlers: false,
          debug: !coreConfig.isProduction,
          playground: !coreConfig.isProduction,
          path: appConfig.endpoint,
          context({ req }) {
            return appContextService.createContext(req);
          },
        };
      },
    }),
    LoggerModule,
    AuthModule,
    SecurityCodeModule,
  ],
})
export class AppModule {}
