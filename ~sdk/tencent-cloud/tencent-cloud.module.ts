import { Module } from '@nestjs/common';
import { ConfigModule } from '~config';
import { tencentCloudConfig } from './tencent-cloud.config';

const config = ConfigModule.forFeature(tencentCloudConfig);

@Module({
  imports: [config],
  exports: [config],
})
export class TencentCloudModule {}
