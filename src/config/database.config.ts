import { registerAs } from '@nestjs/config';
import { Prisma } from '@prisma/client';

export const databaseConfig = registerAs(
  'database',
  function (): Prisma.Datasource {
    return {
      url: process.env.DATABASE_URL,
    };
  },
);
