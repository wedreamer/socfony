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

export const AuthorizationTokenDecorator = createParamDecorator(function (
  args: Prisma.AuthorizationTokenArgs,
  context: ExecutionContext,
) {
  const { authorizationTokenClient } = resolveAppExecutionContext(context);
  if (authorizationTokenClient instanceof Function) {
    return authorizationTokenClient(args);
  }
});

export const UserDecorator = createParamDecorator(function (
  args: Prisma.UserArgs,
  context: ExecutionContext,
) {
  const { userClient } = resolveAppExecutionContext(context);
  if (userClient instanceof Function) {
    return userClient(args);
  }
});
