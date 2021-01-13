import {
  applyDecorators,
  createParamDecorator,
  ExecutionContext,
  SetMetadata,
  UseGuards,
} from '@nestjs/common';
import { Prisma } from '@prisma/client';
import { resolveAppExecutionContext } from 'src/helper';
import { AuthGuard } from './auth.guard';

/**
 * Need validate HTTP endpoint `Authorization` token decorator.
 * @param param validate HTTP endpoit `Authorization` token options.
 * @param param.hasAuthorization Has need validate
 * @param param.type validate token type.
 */
export function AuthorizationDecorator({
  hasAuthorization = true,
  type = 'auth',
}: {
  hasAuthorization?: boolean;
  type?: 'auth' | 'refresh';
}) {
  return applyDecorators(
    SetMetadata('validate-authorization', hasAuthorization),
    SetMetadata('validate-authorization-type', type),
    UseGuards(AuthGuard),
  );
}

/**
 * Get HTTP endpoint `Authorization` token Prisma client decorator.
 */
export const AuthorizationTokenDecorator = createParamDecorator(function (
  args: Prisma.AuthorizationTokenArgs,
  context: ExecutionContext,
) {
  const { authorizationTokenClient } = resolveAppExecutionContext(context);
  if (authorizationTokenClient instanceof Function) {
    return authorizationTokenClient(args);
  }
});

/**
 * Get HTTP endpoint `Authorization` token bound user Prisma client decorator.
 */
export const UserDecorator = createParamDecorator(function (
  args: Prisma.UserArgs,
  context: ExecutionContext,
) {
  const { userClient } = resolveAppExecutionContext(context);
  if (userClient instanceof Function) {
    return userClient(args);
  }
});
