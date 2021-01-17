import { Module } from '@nestjs/common';
import { AuthModule } from '~auth';
import { CoreModule } from '~core';
import { SecurityCodeModule as _ } from '~security-code';
import { SecurityCodeResolver } from './security-code.resolver';

@Module({
  imports: [_, CoreModule, AuthModule],
  providers: [SecurityCodeResolver],
})
export class SecurityCodeModule {}
