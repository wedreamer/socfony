import { Injectable } from '@nestjs/common';
import { TencentCloudService } from '../tencent-cloud.service';
import { Client } from 'tencentcloud-sdk-nodejs/tencentcloud/services/sts/v20180813/sts_client';

@Injectable()
export class TencentCloudStsService {
  constructor(private readonly tencentCloudService: TencentCloudService) {}

  async createClient(region: string = 'ap-guangzhou'): Promise<Client> {
    return new Client({
      region,
      credential: await this.tencentCloudService.getCredential(),
      profile: {
        httpProfile: {
          endpoint: 'sts.tencentcloudapi.com',
        },
      },
    });
  }
}
