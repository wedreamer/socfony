import { ConfigType, registerAs } from '@nestjs/config';

export const tencentCloudCosConfig = registerAs(
  'tencent-cloud:cos',
  function () {
    return {
      bucket: process.env.TENCENT_CLOUD_COS_BUCKET,
      region: process.env.TENCENT_CLOUD_COS_REGION,
    };
  },
);

export type TencentCloudCosConfig = ConfigType<typeof tencentCloudCosConfig>;
