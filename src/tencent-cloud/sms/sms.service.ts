import { Injectable, OnModuleInit } from '@nestjs/common';
import { Client } from 'tencentcloud-sdk-nodejs/tencentcloud/services/sms/v20190711/sms_client';
import { SendSmsRequest } from 'tencentcloud-sdk-nodejs/tencentcloud/services/sms/v20190711/sms_models';
import { ClientConfig } from 'tencentcloud-sdk-nodejs/tencentcloud/common/interface';
import { TencentCloudService } from '../tencent-cloud.service';
import { PrismaClient } from '@prisma/client';
import { ModuleRef } from '@nestjs/core';

@Injectable()
export class TencentCloudShortMessageService implements OnModuleInit {
  constructor(
    private readonly tencentCloudService: TencentCloudService,
    private readonly prisma: PrismaClient,
  ) {}

  onModuleInit() {
    // console.log(this.moduleRef.get(TencentCloudService));
    // forwardRef(() => TencentCloudModule)
    // this.tencentCloudService = this.moduleRef.get(TencentCloudService);
  }

  async createClient() {
    return new Client(await this.getClientOptions());
  }

  async getClientOptions(): Promise<ClientConfig> {
    return {
      credential: await this.tencentCloudService.getCredential(),
      region: 'ap-guangzhou',
      profile: {
        httpProfile: {
          endpoint: 'sms.tencentcloudapi.com',
        },
      },
    };
  }

  async getShortMessageServiceOptions(): Promise<
    Pick<SendSmsRequest, 'SmsSdkAppid' | 'Sign' | 'ExtendCode' | 'SenderId'>
  > {
    const setting = await this.prisma.setting.findUnique({
      where: {
        namespace_name: {
          namespace: 'tencent-cloud',
          name: 'sms',
        },
      },
    });
    const { appId, sign, extendCode, senderId } = (setting?.value as any) || {};

    return {
      SmsSdkAppid: appId,
      Sign: sign,
      ExtendCode: extendCode,
      SenderId: senderId,
    };
  }

  async send(
    params: Pick<
      SendSmsRequest,
      'PhoneNumberSet' | 'TemplateID' | 'TemplateParamSet' | 'SessionContext'
    >,
  ) {
    const client = await this.createClient();
    const request = Object.assign(
      await this.getShortMessageServiceOptions(),
      params,
    );
    return await client.SendSms(request);
  }
}
