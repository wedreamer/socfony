import { AuthModule as _ } from '~auth';
import { NestJS_Common } from '~deps';
import { AuthResolver } from './auth.resolver';
import { CoreModule } from '~core';
import { PrismaModule } from '~prisma';
import { CosAuthorizationResolver } from './cos.resolver';
import { TencentCloudCosModule } from '~sdk/tencent-cloud';

@NestJS_Common.Module({
  imports: [_, CoreModule, PrismaModule, TencentCloudCosModule],
  providers: [AuthResolver, CosAuthorizationResolver],
})
export class AuthModule {}
