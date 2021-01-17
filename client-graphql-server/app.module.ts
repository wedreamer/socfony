import { NestJS } from '~deps';
import { ConfigModule } from 'server-kernel/config';
import { AppContextService, CoreConfig, coreConfig, CoreModule } from 'server-kernel/core';
import { LoggerModule } from 'server-kernel/logger';
import { AppConfig, appConfig } from './app.config';
import { AuthModule } from './auth';
import { SecurityCodeModule } from './security-code';

@NestJS.Common.Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      load: [appConfig],
    }),
    NestJS.GraphQL.GraphQLModule.forRootAsync({
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
