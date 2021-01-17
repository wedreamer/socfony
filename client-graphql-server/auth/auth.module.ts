import { AuthModule as _ } from '~auth';
import { Module } from '@nestjs/common';
import { AuthResolver } from './auth.resolver';
import { CoreModule } from '~core';
import { PrismaModule } from '~prisma';
import { CosAuthorizationResolver } from './cos.resolver';
import { TencentCloudCosModule } from '~sdk/tencent-cloud';

@Module({
  imports: [_, CoreModule, PrismaModule, TencentCloudCosModule],
  providers: [AuthResolver, CosAuthorizationResolver],
})
export class AuthModule {}
