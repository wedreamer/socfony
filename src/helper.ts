import { ExecutionContext } from '@nestjs/common';
import { GqlContextType, GqlExecutionContext } from '@nestjs/graphql';
import { Request } from 'express';
import { AppExecutionContext } from './global';

export function resolveAppExecutionContext(
  context: ExecutionContext,
): AppExecutionContext {
  if (context.getType<GqlContextType>() === 'graphql') {
    const appContext = GqlExecutionContext.create(
      context,
    ).getContext<AppExecutionContext>();

    return {
      ...appContext,
      hasLogged: appContext.request?.hasLogged || appContext.hasLogged,
    };
  }

  return context.switchToHttp().getRequest<Request & AppExecutionContext>();
}
