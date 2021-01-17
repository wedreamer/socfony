import { NestJS_Config } from '~deps';

/**
 * The application configuration.
 */
export const appConfig = NestJS_Config.registerAs('app', function () {
  return {
    port: process.env.APP_PORT || 3000,
    endpoint: process.env.APP_ENDPOINT || '/',
  };
});

/**
 * The application configuration type.
 */
export type AppConfig = NestJS_Config.ConfigType<typeof appConfig>;
