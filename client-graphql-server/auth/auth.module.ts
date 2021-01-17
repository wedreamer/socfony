import { AuthModule as _ } from 'server-kernel/auth';
import { NestJS } from '~deps';
import { AuthResolver } from './auth.resolver';
import { CoreModule } from 'server-kernel/core';
import { PrismaModule } from 'server-kernel/prisma';
import { CosAuthorizationResolver } from './cos.resolver';
import { TencentCloudCosModule } from 'server-kernel/sdk/tencent-cloud';

@NestJS.Common.Module({
  imports: [_, CoreModule, PrismaModule, TencentCloudCosModule],
  providers: [AuthResolver, CosAuthorizationResolver],
})
export class AuthModule {}
