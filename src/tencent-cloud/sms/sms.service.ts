import { Inject, Injectable } from '@nestjs/common';
import { Client } from 'tencentcloud-sdk-nodejs/tencentcloud/services/sms/v20190711/sms_client';
import { SendSmsRequest } from 'tencentcloud-sdk-nodejs/tencentcloud/services/sms/v20190711/sms_models';
import { ClientConfig } from 'tencentcloud-sdk-nodejs/tencentcloud/common/interface';
import { serviceConfig, ServiceConfig } from 'src/config';

@Injectable()
export class TencentCloudShortMessageService {
  constructor(
    @Inject(serviceConfig.KEY)
    private readonly serviceConfig: ServiceConfig,
  ) {}

  createClient() {
    return new Client(this.getClientOptions());
  }

  getClientOptions(): ClientConfig {
    return {
      credential: this.serviceConfig.tencentCloud.credential,
      region: 'ap-guangzhou',
      profile: {
        httpProfile: {
          endpoint: 'sms.tencentcloudapi.com',
        },
      },
    };
  }

  getShortMessageServiceOptions(): Pick<
    SendSmsRequest,
    'SmsSdkAppid' | 'Sign' | 'ExtendCode' | 'SenderId'
  > {
    return this.serviceConfig.tencentCloud.sms.base;
  }

  async send(
    params: Pick<
      SendSmsRequest,
      'PhoneNumberSet' | 'TemplateID' | 'TemplateParamSet' | 'SessionContext'
    >,
  ) {
    const client = this.createClient();
    const request = Object.assign(this.getShortMessageServiceOptions(), params);
    return await client.SendSms(request);
  }
}
