import { NestJS } from '~deps';
import { Prisma } from 'server-kernel/prisma';

/**
 * The application database configuration.
 */
export const databaseConfig = NestJS.Config.registerAs(
  'database',
  function (): Prisma.Datasource {
    return {
      url: process.env.DATABASE_URL,
    };
  },
);
