import { NestJS } from '~deps';
import {
  ConfigFactory,
  ConfigModuleOptions as _Options,
} from '@nestjs/config/dist/interfaces';

const globalOptions: _Options = {
  cache: true,
  envFilePath: '.env',
  expandVariables: true,
};

export type ConfigModuleOptions = Pick<_Options, 'isGlobal' | 'load'>;

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

  static forFeature(config: ConfigFactory): NestJS.Common.DynamicModule {
    return NestJS.Config.ConfigModule.forFeature(config);
  }
}
