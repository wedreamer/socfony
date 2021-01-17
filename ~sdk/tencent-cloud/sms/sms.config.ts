import { registerAs } from '@nestjs/config';
import { SendSmsRequest } from 'tencentcloud-sdk-nodejs/tencentcloud/services/sms/v20190711/sms_models';

export type TencentCloudSmsConfig = Pick<
  SendSmsRequest,
  'SmsSdkAppid' | 'Sign' | 'ExtendCode' | 'SenderId'
>;

export const tencentCloudSmsConfig = registerAs(
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
/*

authorization: {
            expiredIn: Number.parseInt(
              process.env.TENCENT_CLOUD_SMS_AUTHORIZATION_EXPIRED_IN,
            ),
            china: {
              templateId:
                process.env.TENCENT_CLOUD_SMS_AUTHORIZATION_CHINA_TEMPLATE_ID,
              veriables: process.env.TENCENT_CLOUD_SMS_AUTHORIZATION_CHINA_VERIABLES.split(
                ',',
              ),
            },
            other: {
              templateId:
                process.env.TENCENT_CLOUD_SMS_AUTHORIZATION_OTHER_TEMPLATE_ID,
              veriables: process.env.TENCENT_CLOUD_SMS_AUTHORIZATION_OTHER_VERIABLES.split(
                ',',
              ),
            },
          },


*/
