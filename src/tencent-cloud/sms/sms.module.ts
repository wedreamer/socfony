import { Module } from '@nestjs/common';
import { TencentCloudShortMessageService } from './sms.service';

/**
 * Tencent Cloud short message service module.
 */
@Module({
  providers: [TencentCloudShortMessageService],
  exports: [TencentCloudShortMessageService],
})
export class TencentCloudShortMessageServiceModule {}
