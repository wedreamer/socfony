import { NestJS, TencentCloud } from '~deps';
import {
  TencentCloudConfig,
  tencentCloudConfig,
} from '../tencent-cloud.config';

/**
 * Tencent Cloud STS service.
 */
@NestJS.Common.Injectable()
export class TencentCloudStsService {
  constructor(
    @NestJS.Common.Inject(tencentCloudConfig.KEY)
    private readonly tencentCloudConfig: TencentCloudConfig,
  ) {}

  /**
   * Create STS client for region.
   * @param region server region.
   */
  createClient(region: string = 'ap-guangzhou'): TencentCloud.STS.Client {
    return new TencentCloud.STS.Client({
      region,
      credential: this.tencentCloudConfig,
      profile: {
        httpProfile: {
          endpoint: 'sts.tencentcloudapi.com',
        },
      },
    });
  }
}
