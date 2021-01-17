import { ConfigType, registerAs } from '@nestjs/config';

/**
 * The application configuration.
 */
export const appConfig = registerAs('app', function () {
  return {
    port: process.env.APP_PORT || 3000,
    endpoint: process.env.APP_ENDPOINT || '/',
  };
});

/**
 * The application configuration type.
 */
export type AppConfig = ConfigType<typeof appConfig>;
