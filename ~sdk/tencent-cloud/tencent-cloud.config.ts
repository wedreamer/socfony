import { ConfigType, registerAs } from '@nestjs/config';

export const tencentCloudConfig = registerAs('tencent-cloud', function () {
  return {
    secretId: process.env.TENCENT_CLOUD_SECRET_ID,
    secretKey: process.env.TENCENT_CLOUD_SECRET_KEY,
  };
});

export type TencentCloudConfig = ConfigType<typeof tencentCloudConfig>;
