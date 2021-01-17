import { NestJS } from '~deps';
import { TencentCloudModule } from '../tencent-cloud.module';
import { TencentCloudStsService } from './sts.service';

/**
 * Tencent Cloud STS module.
 */
@NestJS.Common.Module({
  imports: [TencentCloudModule],
  providers: [TencentCloudStsService],
  exports: [TencentCloudStsService],
})
export class TencentCloudStsModule {}
