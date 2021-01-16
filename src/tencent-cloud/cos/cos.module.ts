import { Module } from '@nestjs/common';
import { TencentCloudStsModule } from '../sts';
import { TencentCloudCosService } from './cos.service';

/**
 * Tencent Cloud COS module.
 */
@Module({
  imports: [TencentCloudStsModule],
  providers: [TencentCloudCosService],
  exports: [TencentCloudCosService],
})
export class TencentCloudCosModule {}
