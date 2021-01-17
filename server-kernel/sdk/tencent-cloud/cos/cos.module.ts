import { NestJS } from '~deps';
import { ConfigModule } from 'server-kernel/config';
import { TencentCloudStsModule } from '../sts';
import { tencentCloudCosConfig } from './cos.config';
import { TencentCloudCosService } from './cos.service';

/**
 * Tencent Cloud COS module.
 */
@NestJS.Common.Module({
  imports: [
    TencentCloudStsModule,
    ConfigModule.forFeature(tencentCloudCosConfig),
  ],
  providers: [TencentCloudCosService],
  exports: [TencentCloudCosService],
})
export class TencentCloudCosModule {}
