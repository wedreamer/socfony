import { ConfigType, registerAs } from '@nestjs/config';

/**
 * `NODE_ENV` enum.
 */
export enum NodeEnv {
  DEVELOPMENT = 'development',
  PRODUCTION = 'production',
}

/**
 * The application configuration.
 */
export const appConfig = registerAs('app', function () {
  const mode: NodeEnv =
    (process.env.NODE_ENV as NodeEnv) || NodeEnv.DEVELOPMENT;
  return {
    mode,
    isProduction: mode === NodeEnv.PRODUCTION,
    port: process.env.APP_PORT || 3000,
    endpoint: process.env.APP_ENDPOINT || '/',
  };
});

/**
 * The application configuration type.
 */
export type AppConfig = ConfigType<typeof appConfig>;
