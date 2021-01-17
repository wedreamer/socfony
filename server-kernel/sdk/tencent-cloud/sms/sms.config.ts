import { NestJS } from '~deps';
import { SendSmsRequest } from 'tencentcloud-sdk-nodejs/tencentcloud/services/sms/v20190711/sms_models';

export type TencentCloudSmsConfig = Pick<
  SendSmsRequest,
  'SmsSdkAppid' | 'Sign' | 'ExtendCode' | 'SenderId'
>;

export const tencentCloudSmsConfig = NestJS.Config.registerAs(
  'tencent-cloud:sms/base',
  function (): TencentCloudSmsConfig {
    return {
      SmsSdkAppid: process.env.TENCENT_CLOUD_SMS_APP_ID,
      Sign: process.env.TENCENT_CLOUD_SMS_SIGN,
      ExtendCode: process.env.TENCENT_CLOUD_SMS_EXTEND_CODE,
      SenderId: process.env.TENCENT_CLOUD_SMS_SENDER_ID,
    };
  },
);
