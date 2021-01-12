import { Module } from '@nestjs/common';
import { TencentCloudShortMessageService } from './sms.service';

@Module({
  providers: [TencentCloudShortMessageService],
  exports: [TencentCloudShortMessageService],
})
export class TencentCloudShortMessageServiceModule {}
