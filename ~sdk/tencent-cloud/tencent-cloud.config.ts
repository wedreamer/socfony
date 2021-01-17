import { NestJS_Config } from '~deps';

export const tencentCloudConfig = NestJS_Config.registerAs(
  'tencent-cloud',
  function () {
    return {
      secretId: process.env.TENCENT_CLOUD_SECRET_ID,
      secretKey: process.env.TENCENT_CLOUD_SECRET_KEY,
    };
  },
);

export type TencentCloudConfig = NestJS_Config.ConfigType<
  typeof tencentCloudConfig
>;
