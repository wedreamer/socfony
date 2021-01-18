import { NestJS } from '~deps';

const globalOptions: NestJS.Config.ConfigModuleOptions = {
  cache: true,
  envFilePath: '.env',
  expandVariables: true,
};

export type ConfigModuleOptions = Pick<
  NestJS.Config.ConfigModuleOptions,
  'isGlobal' | 'load'
>;

@NestJS.Common.Module({
  imports: [NestJS.Config.ConfigModule],
  exports: [NestJS.Config.ConfigModule],
})
export class ConfigModule {
  static forRoot(options?: ConfigModuleOptions) {
    return NestJS.Config.ConfigModule.forRoot(
      Object.assign({}, globalOptions, options),
    );
  }

  static forFeature(
    config: NestJS.Config.ConfigFactory,
  ): NestJS.Common.DynamicModule {
    return NestJS.Config.ConfigModule.forFeature(config);
  }
}
