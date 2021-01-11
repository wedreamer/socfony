import { Injectable } from '@nestjs/common';
import { PrismaClient } from '@prisma/client';
import { Credential } from 'tencentcloud-sdk-nodejs/tencentcloud/common/interface';

@Injectable()
export class TencentCloudService {
  constructor(private readonly prisma: PrismaClient) {}

  async getCredential(): Promise<Credential> {
    const setting = await this.prisma.setting.findUnique({
      where: {
        namespace_name: {
          name: 'credential',
          namespace: 'tencent-cloud',
        },
      },
    });
    return setting?.value as Credential;
  }
}
