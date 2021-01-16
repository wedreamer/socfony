import { Module } from '@nestjs/common';
import { TencentCloudShortMessageServiceModule } from 'src/tencent-cloud';
import { SecurityCodeResolver } from './security-code.resolver';
import { SecurityCodeService } from './security-code.service';

/**
 * Sceurity code module.
 */
@Module({
  imports: [TencentCloudShortMessageServiceModule],
  providers: [SecurityCodeService, SecurityCodeResolver],
  exports: [SecurityCodeService],
})
export class SecurityCodeModule {}
