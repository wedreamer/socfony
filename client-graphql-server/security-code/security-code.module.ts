import { NestJS, Kernel } from '~deps';
import { SecurityCodeResolver } from './security-code.resolver';

@NestJS.Common.Module({
  imports: [
    Kernel.SecurityCode.SecurityCodeModule,
    Kernel.Core.CoreModule,
    Kernel.Auth.AuthModule,
  ],
  providers: [SecurityCodeResolver],
})
export class SecurityCodeModule {}
