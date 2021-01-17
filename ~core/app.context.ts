import { NestJS_Common, NestJS_GraphQL } from '~deps';
import { AuthorizationToken, User } from '~prisma';
import { Request } from './express';

export class AppContext {
  /**
   * Authenticated user token
   */
  authorizationToken?: AuthorizationToken;

  /**
   * Authenticated user
   */
  user?: User;

  /**
   * Express request
   */
  request?: Request;

  /**
   * Resolve get application context。
   * @param context NestJS/Apollo context.
   */
  static resolve(context: NestJS_Common.ExecutionContext) {
    if (context.getType<NestJS_GraphQL.GqlContextType>() === 'graphql') {
      return NestJS_GraphQL.GqlExecutionContext.create(
        context,
      ).getContext<AppContext>();
    }

    return context.switchToHttp().getRequest<AppContext>();
  }
}
