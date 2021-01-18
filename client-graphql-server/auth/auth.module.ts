import { NestJS, Kernel } from '~deps';
import { AuthResolver } from './auth.resolver';
import { CosAuthorizationResolver } from './cos.resolver';

@NestJS.Common.Module({
  imports: [
    Kernel.Auth.AuthModule,
    Kernel.Core.CoreModule,
    Kernel.Prisma.PrismaModule,
    Kernel.SDK.TencentCloud.TencentCloudCosModule,
  ],
  providers: [AuthResolver, CosAuthorizationResolver],
})
export class AuthModule {}
