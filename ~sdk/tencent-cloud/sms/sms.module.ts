import { Module } from '@nestjs/common';
import { ConfigModule } from '~config';
import { TencentCloudModule } from '../tencent-cloud.module';
import { tencentCloudSmsConfig } from './sms.config';
import { TencentCloudShortMessageService } from './sms.service';

/**
 * Tencent Cloud short message service module.
 */
@Module({
  imports: [ConfigModule.forFeature(tencentCloudSmsConfig), TencentCloudModule],
  providers: [TencentCloudShortMessageService],
  exports: [TencentCloudShortMessageService],
})
export class TencentCloudShortMessageServiceModule {}
