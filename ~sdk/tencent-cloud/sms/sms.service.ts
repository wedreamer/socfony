import { Inject, Injectable } from '@nestjs/common';
import { Client } from 'tencentcloud-sdk-nodejs/tencentcloud/services/sms/v20190711/sms_client';
import { SendSmsRequest } from 'tencentcloud-sdk-nodejs/tencentcloud/services/sms/v20190711/sms_models';
import { ClientConfig } from 'tencentcloud-sdk-nodejs/tencentcloud/common/interface';
import {
  TencentCloudConfig,
  tencentCloudConfig,
} from '../tencent-cloud.config';
import { tencentCloudSmsConfig, TencentCloudSmsConfig } from './sms.config';

/**
 * Tencent Cloud short message service.
 */
@Injectable()
export class TencentCloudShortMessageService {
  constructor(
    @Inject(tencentCloudConfig.KEY)
    private readonly tencentCloudConfig: TencentCloudConfig,
    @Inject(tencentCloudSmsConfig.KEY)
    private readonly tencentCloudSmsConfig: TencentCloudSmsConfig,
  ) {}

  /**
   * Create Tencent Cloud SMS client.
   */
  createClient() {
    console.log(this.getClientOptions());
    return new Client(this.getClientOptions());
  }

  /**
   * Get Tencent Cloud SMS client options.
   */
  getClientOptions(): ClientConfig {
    return {
      credential: this.tencentCloudConfig,
      region: 'ap-guangzhou',
      profile: {
        httpProfile: {
          endpoint: 'sms.tencentcloudapi.com',
        },
      },
    };
  }

  /**
   * Get Tencent Cloud SMS send options.
   */
  getShortMessageServiceOptions(): Pick<
    SendSmsRequest,
    'SmsSdkAppid' | 'Sign' | 'ExtendCode' | 'SenderId'
  > {
    return this.tencentCloudSmsConfig;
  }

  /**
   * Send SMS.
   * @param params Send SMS params.
   */
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
