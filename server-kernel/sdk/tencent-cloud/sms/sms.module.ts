import { NestJS } from '~deps';
import { ConfigModule } from 'server-kernel/config';
import { TencentCloudModule } from '../tencent-cloud.module';
import { tencentCloudSmsConfig } from './sms.config';
import { TencentCloudShortMessageService } from './sms.service';

/**
 * Tencent Cloud short message service module.
 */
@NestJS.Common.Module({
  imports: [ConfigModule.forFeature(tencentCloudSmsConfig), TencentCloudModule],
  providers: [TencentCloudShortMessageService],
  exports: [TencentCloudShortMessageService],
})
export class TencentCloudShortMessageServiceModule {}
