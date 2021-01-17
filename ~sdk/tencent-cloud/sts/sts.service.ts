import { Inject, Injectable } from '@nestjs/common';
import { Client } from 'tencentcloud-sdk-nodejs/tencentcloud/services/sts/v20180813/sts_client';
import {
  TencentCloudConfig,
  tencentCloudConfig,
} from '../tencent-cloud.config';

/**
 * Tencent Cloud STS service.
 */
@Injectable()
export class TencentCloudStsService {
  constructor(
    @Inject(tencentCloudConfig.KEY)
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
