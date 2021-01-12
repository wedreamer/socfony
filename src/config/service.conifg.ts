import { ConfigType, registerAs } from '@nestjs/config';

export const serviceConfig = registerAs('service', function () {
  return {
    tencentCloud: {
      credential: {
        secretId: process.env.TENCENT_CLOUD_SECRET_ID,
        secretKey: process.env.TENCENT_CLOUD_SECRET_KEY,
      },
      cos: {
        bucket: process.env.TENCENT_CLOUD_COS_BUCKET,
        region: process.env.TENCENT_CLOUD_COS_REGION,
      },
      sms: {
        base: {
          SmsSdkAppid: process.env.TENCENT_CLOUD_SMS_APP_ID,
          Sign: process.env.TENCENT_CLOUD_SMS_SIGN,
          ExtendCode: process.env.TENCENT_CLOUD_SMS_EXTEND_CODE,
          SenderId: process.env.TENCENT_CLOUD_SMS_SENDER_ID,
        },
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
      },
    },
  };
});

export type ServiceConfig = ConfigType<typeof serviceConfig>;
