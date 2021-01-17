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
export const coreConfig = registerAs('core', function () {
  const mode: NodeEnv =
    (process.env.NODE_ENV as NodeEnv) || NodeEnv.DEVELOPMENT;
  return {
    mode,
    isProduction: mode === NodeEnv.PRODUCTION,
  };
});

/**
 * The application configuration type.
 */
export type CoreConfig = ConfigType<typeof coreConfig>;
