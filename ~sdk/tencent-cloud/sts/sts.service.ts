import { NestJS_Common } from '~deps';
import { Client } from 'tencentcloud-sdk-nodejs/tencentcloud/services/sts/v20180813/sts_client';
import {
  TencentCloudConfig,
  tencentCloudConfig,
} from '../tencent-cloud.config';

/**
 * Tencent Cloud STS service.
 */
@NestJS_Common.Injectable()
export class TencentCloudStsService {
  constructor(
    @NestJS_Common.Inject(tencentCloudConfig.KEY)
    private readonly tencentCloudConfig: TencentCloudConfig,
  ) {}

  /**
   * Create STS client for region.
   * @param region server region.
   */
  createClient(region: string = 'ap-guangzhou'): Client {
    return new Client({
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
