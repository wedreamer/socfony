import { ExecutionContext } from '@nestjs/common';
import { GqlContextType, GqlExecutionContext } from '@nestjs/graphql';
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
  static resolve(context: ExecutionContext) {
    if (context.getType<GqlContextType>() === 'graphql') {
      return GqlExecutionContext.create(context).getContext<AppContext>();
    }

    return context.switchToHttp().getRequest<AppContext>();
  }
}
