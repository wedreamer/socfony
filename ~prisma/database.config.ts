import { NestJS_Config } from '~deps';
import { Prisma } from '~prisma';

/**
 * The application database configuration.
 */
export const databaseConfig = NestJS_Config.registerAs(
  'database',
  function (): Prisma.Datasource {
    return {
      url: process.env.DATABASE_URL,
    };
  },
);
