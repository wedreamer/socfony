import { ConfigType, registerAs } from '@nestjs/config';

export enum NodeEnv {
  DEVELOPMENT = 'development',
  PRODUCTION = 'production',
}

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

export type AppConfig = ConfigType<typeof appConfig>;
