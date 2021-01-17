import { DynamicModule, Module } from '@nestjs/common';
import { ConfigModule as _ } from '@nestjs/config';
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

@Module({
  imports: [_],
  exports: [_],
})
export class ConfigModule {
  static forRoot(options?: ConfigModuleOptions) {
    return _.forRoot(Object.assign({}, globalOptions, options));
  }

  static forFeature(config: ConfigFactory): DynamicModule {
    return _.forFeature(config);
  }
}
