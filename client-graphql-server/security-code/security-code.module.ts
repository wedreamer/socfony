import { NestJS } from '~deps';
import { AuthModule } from 'server-kernel/auth';
import { CoreModule } from 'server-kernel/core';
import { SecurityCodeModule as _ } from 'server-kernel/security-code';
import { SecurityCodeResolver } from './security-code.resolver';

@NestJS.Common.Module({
  imports: [_, CoreModule, AuthModule],
  providers: [SecurityCodeResolver],
})
export class SecurityCodeModule {}
