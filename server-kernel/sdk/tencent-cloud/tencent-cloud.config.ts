import { NestJS } from '~deps';

export const tencentCloudConfig = NestJS.Config.registerAs(
  'tencent-cloud',
  function () {
    return {
      secretId: process.env.TENCENT_CLOUD_SECRET_ID,
      secretKey: process.env.TENCENT_CLOUD_SECRET_KEY,
    };
  },
);

export type TencentCloudConfig = NestJS.Config.ConfigType<
  typeof tencentCloudConfig
>;
