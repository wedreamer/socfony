import { NestJS, Kernel } from '~deps';
import { AppConfig, appConfig } from './app.config';
import { AuthModule } from './auth';
import { SecurityCodeModule } from './security-code';

@NestJS.Common.Module({
  imports: [
    Kernel.Config.ConfigModule.forRoot({
      isGlobal: true,
      load: [appConfig],
    }),
    NestJS.GraphQL.GraphQLModule.forRootAsync({
      imports: [Kernel.Core.CoreModule],
      inject: [
        Kernel.Core.coreConfig.KEY,
        appConfig.KEY,
        Kernel.Core.AppContextService,
      ],
      useFactory(
        coreConfig: Kernel.Core.CoreConfig,
        appConfig: AppConfig,
        appContextService: Kernel.Core.AppContextService,
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
    Kernel.Logger.LoggerModule,
    AuthModule,
    SecurityCodeModule,
  ],
})
export class AppModule {}
