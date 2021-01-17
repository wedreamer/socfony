import { NestJS_Config } from '~deps';

export const tencentCloudCosConfig = NestJS_Config.registerAs(
  'tencent-cloud:cos',
  function () {
    return {
      bucket: process.env.TENCENT_CLOUD_COS_BUCKET,
      region: process.env.TENCENT_CLOUD_COS_REGION,
    };
  },
);

export type TencentCloudCosConfig = NestJS_Config.ConfigType<
  typeof tencentCloudCosConfig
>;
