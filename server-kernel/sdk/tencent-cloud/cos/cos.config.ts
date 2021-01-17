import { NestJS } from '~deps';

export const tencentCloudCosConfig = NestJS.Config.registerAs(
  'tencent-cloud:cos',
  function () {
    return {
      bucket: process.env.TENCENT_CLOUD_COS_BUCKET,
      region: process.env.TENCENT_CLOUD_COS_REGION,
    };
  },
);

export type TencentCloudCosConfig = NestJS.Config.ConfigType<
  typeof tencentCloudCosConfig
>;
