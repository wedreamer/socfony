import { ExecutionContext } from '@nestjs/common';
import { GqlContextType, GqlExecutionContext } from '@nestjs/graphql';
import { Request } from 'express';
import { customAlphabet, nanoid } from 'nanoid';
import { AppExecutionContext } from './global';

/**
 * Resolve get application context。
 * @param context NestJS/Apollo context.
 */
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

/**
 * create [a-Z0-9-_] Nano ID.
 * @param length need create size.
 */
export function nanoIdGenerator(length: number): string {
  return nanoid(length);
}

/**
 * Crate only number(0-9) Nano ID.
 * @param length need create size.
 */
export function numberNanoIdGenerator(length: number): string {
  return customAlphabet('1234567890', length)();
}

/**
 * Crate only alphabet(A-Z) Nano ID.
 * @param length need create size.
 */
export function alphabetNanoIdGenerator(length: number): string {
  return customAlphabet('qwertyuiopasdfghjklzxcvbnm'.toUpperCase(), length)();
}

/**
 * Crate only [23456789qwertyupasdfghjklzxcvbnm] Nano ID.
 * @param length need create size.
 */
export function readabilityNanoIdGenerator(length: number): string {
  return customAlphabet(
    '23456789qwertyupasdfghjklzxcvbnm'.toUpperCase(),
    length,
  )();
}
