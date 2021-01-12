import { ExecutionContext } from '@nestjs/common';
import { GqlContextType, GqlExecutionContext } from '@nestjs/graphql';
import { Request } from 'express';
import { customAlphabet, nanoid } from 'nanoid';
import { AppExecutionContext } from './global';

export function resolveAppExecutionContext(
  context: ExecutionContext,
): AppExecutionContext {
  if (context.getType<GqlContextType>() === 'graphql') {
    const appContext = GqlExecutionContext.create(
      context,
    ).getContext<AppExecutionContext>();
    appContext.hasLogged =
      appContext.request?.hasLogged || appContext.hasLogged;

    return appContext;
  }

  return context.switchToHttp().getRequest<Request & AppExecutionContext>();
}

export function nanoIdGenerator(length: number): string {
  return nanoid(length);
}

export function numberNanoIdGenerator(length: number): string {
  return customAlphabet('1234567890', length)();
}

export function alphabetNanoIdGenerator(length: number): string {
  return customAlphabet('qwertyuiopasdfghjklzxcvbnm'.toUpperCase(), length)();
}

export function readabilityNanoIdGenerator(length: number): string {
  return customAlphabet(
    '23456789qwertyupasdfghjklzxcvbnm'.toUpperCase(),
    length,
  )();
}
