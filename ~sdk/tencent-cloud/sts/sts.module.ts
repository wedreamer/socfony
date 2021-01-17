import { Module } from '@nestjs/common';
import { TencentCloudModule } from '../tencent-cloud.module';
import { TencentCloudStsService } from './sts.service';

/**
 * Tencent Cloud STS module.
 */
@Module({
  imports: [TencentCloudModule],
  providers: [TencentCloudStsService],
  exports: [TencentCloudStsService],
})
export class TencentCloudStsModule {}
