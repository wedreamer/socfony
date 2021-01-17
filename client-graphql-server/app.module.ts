import { NestJS_Common, NestJS_GraphQL } from '~deps';
import { ConfigModule } from '~config';
import { AppContextService, CoreConfig, coreConfig, CoreModule } from '~core';
import { LoggerModule } from '~logger';
import { AppConfig, appConfig } from './app.config';
import { AuthModule } from './auth';
import { SecurityCodeModule } from './security-code';

@NestJS_Common.Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      load: [appConfig],
    }),
    NestJS_GraphQL.GraphQLModule.forRootAsync({
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
