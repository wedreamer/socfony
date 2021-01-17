import { NestJS_Common, NestJS_Config } from '~deps';
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

@NestJS_Common.Module({
  imports: [NestJS_Config.ConfigModule],
  exports: [NestJS_Config.ConfigModule],
})
export class ConfigModule {
  static forRoot(options?: ConfigModuleOptions) {
    return NestJS_Config.ConfigModule.forRoot(
      Object.assign({}, globalOptions, options),
    );
  }

  static forFeature(config: ConfigFactory): NestJS_Common.DynamicModule {
    return NestJS_Config.ConfigModule.forFeature(config);
  }
}
