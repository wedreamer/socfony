import { NestJS, TencentCloud } from '~deps';
import {
  TencentCloudConfig,
  tencentCloudConfig,
} from '../tencent-cloud.config';
import { tencentCloudSmsConfig, TencentCloudSmsConfig } from './sms.config';

/**
 * Tencent Cloud short message service.
 */
@NestJS.Common.Injectable()
export class TencentCloudShortMessageService {
  constructor(
    @NestJS.Common.Inject(tencentCloudConfig.KEY)
    private readonly tencentCloudConfig: TencentCloudConfig,
    @NestJS.Common.Inject(tencentCloudSmsConfig.KEY)
    private readonly tencentCloudSmsConfig: TencentCloudSmsConfig,
  ) {}

  /**
   * Create Tencent Cloud SMS client.
   */
  createClient() {
    return new TencentCloud.SMS.Client(this.getClientOptions());
  }

  /**
   * Get Tencent Cloud SMS client options.
   */
  getClientOptions(): TencentCloud.Common.ClientConfig {
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
    TencentCloud.SMS.SendSmsRequest,
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
      TencentCloud.SMS.SendSmsRequest,
      'PhoneNumberSet' | 'TemplateID' | 'TemplateParamSet' | 'SessionContext'
    >,
  ) {
    const client = this.createClient();
    const request = Object.assign(this.getShortMessageServiceOptions(), params);
    return await client.SendSms(request);
  }
}
