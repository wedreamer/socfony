export const expiredIn = Number.parseInt(
  process.env.TENCENT_CLOUD_SMS_AUTHORIZATION_EXPIRED_IN || '300',
);

export const china = {
  templateId: process.env.TENCENT_CLOUD_SMS_AUTHORIZATION_CHINA_TEMPLATE_ID,
  veriables: process.env.TENCENT_CLOUD_SMS_AUTHORIZATION_CHINA_VERIABLES.split(
    ',',
  ),
};

export const other = {
  templateId: process.env.TENCENT_CLOUD_SMS_AUTHORIZATION_OTHER_TEMPLATE_ID,
  veriables: process.env.TENCENT_CLOUD_SMS_AUTHORIZATION_OTHER_VERIABLES.split(
    ',',
  ),
};
