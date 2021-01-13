import { Inject, Injectable } from '@nestjs/common';
import {
  GqlModuleOptions,
  GqlOptionsFactory as GqlOptionsFactoryInterface,
} from '@nestjs/graphql';
import { AuthorizationService } from 'src/authorization/authorization.service';
import { appConfig, AppConfig } from 'src/config';

/**
 * GraphQL module options factory.
 */
@Injectable()
export class GqlOptionsFactory implements GqlOptionsFactoryInterface {
  constructor(
    private readonly authoriztionService: AuthorizationService,
    @Inject(appConfig.KEY)
    private readonly appConfig: AppConfig,
  ) {}

  /**
   * Create GraphQL module options.
   */
  async createGqlOptions(): Promise<GqlModuleOptions> {
    return {
      autoSchemaFile: true,
      installSubscriptionHandlers: false,
      debug: !this.appConfig.isProduction,
      playground: !this.appConfig.isProduction,
      path: this.appConfig.endpoint,
      context: this.context.bind(this),
    };
  }

  /**
   * GraphQL context resolver.
   * @param context NestJS context or Apollo server context.
   */
  private context(context: any) {
    const { req: request } = context;

    return Object.assign(
      context,
      this.authoriztionService.resolveHttpContext(request),
    );
  }
}
