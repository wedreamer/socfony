import { Inject, Injectable } from '@nestjs/common';
import { Client } from 'tencentcloud-sdk-nodejs/tencentcloud/services/sts/v20180813/sts_client';
import { serviceConfig, ServiceConfig } from 'src/config';

@Injectable()
export class TencentCloudStsService {
  constructor(
    @Inject(serviceConfig.KEY)
    private readonly serviceConfig: ServiceConfig,
  ) {}

  createClient(region: string = 'ap-guangzhou'): Client {
    return new Client({
      region,
      credential: this.serviceConfig.tencentCloud.credential,
      profile: {
        httpProfile: {
          endpoint: 'sts.tencentcloudapi.com',
        },
      },
    });
  }
}
