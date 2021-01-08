import { Injectable } from '@nestjs/common';
import {
  GqlModuleOptions,
  GqlOptionsFactory as GqlOptionsFactoryInterface,
} from '@nestjs/graphql';
import { AuthorizationService } from 'src/authorization/authorization.service';

@Injectable()
export class GqlOptionsFactory implements GqlOptionsFactoryInterface {
  constructor(private readonly authoriztionService: AuthorizationService) {}

  async createGqlOptions(): Promise<GqlModuleOptions> {
    return {
      autoSchemaFile: true,
      installSubscriptionHandlers: false,
      debug: true,
      playground: true,
      path: '/',
      context: this.context.bind(this),
    };
  }

  private context(context: any) {
    const { req: request } = context;

    return Object.assign(
      context,
      this.authoriztionService.resolveHttpContext(request),
    );
  }
}
