import { NestJS, TencentCloud } from '~deps';

export type TencentCloudSmsConfig = Pick<
  TencentCloud.SMS.SendSmsRequest,
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
