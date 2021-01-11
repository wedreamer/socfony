import {
  createParamDecorator,
  ExecutionContext,
  SetMetadata,
} from '@nestjs/common';
import { Prisma } from '@prisma/client';
import { resolveAppExecutionContext } from 'src/helper';

export function AuthorizationDecorator(hasAuthorization: boolean = true) {
  return SetMetadata('validate-authorization', hasAuthorization);
}

export const AuthorizationTokenDecorator = createParamDecorator(function (
  args: Prisma.AuthorizationTokenArgs,
  context: ExecutionContext,
) {
  const { authorizationToken } = resolveAppExecutionContext(context);
  if (authorizationToken instanceof Function) {
    return authorizationToken(args);
  }
});

export const UserDecorator = createParamDecorator(function (
  args: Prisma.UserArgs,
  context: ExecutionContext,
) {
  const { user } = resolveAppExecutionContext(context);
  if (user instanceof Function) {
    return user(args);
  }
});
