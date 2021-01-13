import { Global, Module } from '@nestjs/common';
import { PrismaModule } from 'src/prisma';
import { SecurityCodeModule } from 'src/security-code/security-code.module';
import { TencentCloudCosModule } from 'src/tencent-cloud';
import { AuthorizationResolver } from './authorization.resolver';
import { AuthorizationService } from './authorization.service';
import { CosAuthorizationResolver } from './cos.resolver';

@Global()
@Module({
  imports: [PrismaModule, SecurityCodeModule, TencentCloudCosModule],
  providers: [
    AuthorizationService,
    AuthorizationResolver,
    CosAuthorizationResolver,
  ],
  exports: [AuthorizationService],
})
export class AuthorizationModule {}
