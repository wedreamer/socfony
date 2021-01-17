import { NestJS } from '~deps';

export const securityCodeSmsConfig = NestJS.Config.registerAs(
  'security-code:sms',
  function () {
    return {
      expiredIn: Number.parseInt(
        process.env.TENCENT_CLOUD_SMS_AUTHORIZATION_EXPIRED_IN || '300',
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
    };
  },
);

export type SecurityCodeSmsConfig = NestJS.Config.ConfigType<
  typeof securityCodeSmsConfig
>;
