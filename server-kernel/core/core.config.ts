import { NestJS } from '~deps';

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
export const coreConfig = NestJS.Config.registerAs('core', function () {
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
export type CoreConfig = NestJS.Config.ConfigType<typeof coreConfig>;
