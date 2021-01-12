import { Module } from '@nestjs/common';
import { TencentCloudStsService } from './sts.service';

@Module({
  providers: [TencentCloudStsService],
  exports: [TencentCloudStsService],
})
export class TencentCloudStsModule {}
