import { Module } from '@nestjs/common';
import { PrismaModule } from 'src/prisma';
import { TencentCloudShortMessageServiceModule } from 'src/tencent-cloud';
import { SecurityCodeResolver } from './security-code.resolver';
import { SecurityCodeService } from './security-code.service';

@Module({
  imports: [PrismaModule, TencentCloudShortMessageServiceModule],
  providers: [SecurityCodeService, SecurityCodeResolver],
  exports: [SecurityCodeService],
})
export class SecurityCodeModule {}
