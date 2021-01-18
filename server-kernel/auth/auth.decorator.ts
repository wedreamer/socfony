import { NestJS } from '~deps';
import { AppContext } from '../core';
import { AuthGuard } from './auth.guard';
import {
  AUTH_METADATA_HAS_AUTHORIZATION,
  AUTH_METADATA_HAS_AUTHORIZATION_TYPE,
} from './constants';
import { HasTokenExpiredType } from './enums';

export interface AuthDecoratorOptions {
  hasAuthorization?: boolean;
  type?: HasTokenExpiredType;
}

/**
 * Need validate HTTP endpoint `Authorization` token decorator.
 * @param param validate HTTP endpoit `Authorization` token options.
 * @param param.hasAuthorization Has need validate
 * @param param.type validate token type.
 */
export function AuthDecorator(options: AuthDecoratorOptions) {
  return NestJS.Common.applyDecorators(
    NestJS.Common.SetMetadata(
      AUTH_METADATA_HAS_AUTHORIZATION,
      options?.hasAuthorization || true,
    ),
    NestJS.Common.SetMetadata(
      AUTH_METADATA_HAS_AUTHORIZATION_TYPE,
      options?.type || HasTokenExpiredType.AUTH,
    ),
    NestJS.Common.UseGuards(AuthGuard),
  );
}

/**
 * Get HTTP endpoint `Authorization` token Prisma client decorator.
 */
export const AuthorizationTokenDecorator = NestJS.Common.createParamDecorator(
  function (_: any, context: NestJS.Common.ExecutionContext) {
    const { authorizationToken } = AppContext.resolve(context);
    return authorizationToken;
  },
);

/**
 * Get HTTP endpoint `Authorization` token bound user Prisma client decorator.
 */
export const UserDecorator = NestJS.Common.createParamDecorator(function (
  _: any,
  context: NestJS.Common.ExecutionContext,
) {
  const { user } = AppContext.resolve(context);
  return user;
});
