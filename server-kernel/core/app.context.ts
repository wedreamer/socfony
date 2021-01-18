import { NestJS } from '~deps';
import { AuthorizationToken, User } from '../prisma';
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
  static resolve(context: NestJS.Common.ExecutionContext) {
    if (context.getType<NestJS.GraphQL.GqlContextType>() === 'graphql') {
      return NestJS.GraphQL.GqlExecutionContext.create(
        context,
      ).getContext<AppContext>();
    }

    return context.switchToHttp().getRequest<AppContext>();
  }
}
