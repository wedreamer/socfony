import { NestJS_Common } from '~deps';
import { Prisma } from '../client';

/**
 * Create Prisma logger middleware helper.
 * @param logger Logger
 */
export function PrismaLoggerMiddleware(
  logger: NestJS_Common.Logger,
): Prisma.Middleware {
  return function (params, next) {
    logger.debug(
      `Query ${params.model}.${params.action}\nArgs: ${JSON.stringify(
        params.args,
        null,
        2,
      )}`,
      'Prisma',
    );

    return next(params);
  };
}
