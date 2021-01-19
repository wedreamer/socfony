import { NestJS, Kernel } from '~deps';
import { CosAuthorizationEntity } from './entities';

// 暂时设置浏览器通用支持的格式
export enum AllowUploadFileType {
  // 图片
  JPG = '.jpg',
  PNG = '.png',
  GIF = '.gif',
  // 视频
  MP4 = '.mp4',
  OGG = '.ogg',
  // 音频
  MP3 = '.mp3',
  WAV = '.wav',
}

// Register allow upload file type to GraphQL schema.
NestJS.GraphQL.registerEnumType(AllowUploadFileType, {
  name: 'AllowUploadFileType',
  description:
    'Create Tencent Cloud COS write credential allow upload file type.',
});

/**
 * `CosAuthorizationEntity` resolver.
 */
@NestJS.GraphQL.Resolver((of) => CosAuthorizationEntity)
export class CosAuthorizationResolver {
  constructor(
    private readonly cosService: Kernel.SDK.TencentCloud.TencentCloudCosService,
  ) {}

  /**
   * Create Tencent Cloud COS temporary read credential.
   */
  @NestJS.GraphQL.Mutation((returns) => CosAuthorizationEntity, {
    description: 'Create Tencent Cloud COS temporary read credential.',
  })
  @Kernel.Auth.AuthDecorator({
    hasAuthorization: true,
    type: Kernel.Auth.HasTokenExpiredType.AUTH,
  })
  async createCosTemporaryReadCredential(): Promise<CosAuthorizationEntity> {
    const response = await this.cosService.createTemporaryReadCredential();
    return CosAuthorizationEntity.create(response);
  }

  /**
   * Create Tencent Cloud COS temporary write credential.
   * @param type Create Tencent Cloud COS write credential allow upload file type.
   */
  @NestJS.GraphQL.Mutation((returns) => CosAuthorizationEntity)
  @Kernel.Auth.AuthDecorator({
    hasAuthorization: true,
    type: Kernel.Auth.HasTokenExpiredType.AUTH,
  })
  async createCosTemporaryWriteCredential(
    @NestJS.GraphQL.Args({
      name: 'type',
      type: () => AllowUploadFileType,
    })
    type: AllowUploadFileType,
  ): Promise<CosAuthorizationEntity> {
    const resource = Kernel.Core.nanoIdGenerator(64) + type;
    const response = await this.cosService.createTemporaryWriteCredential(
      resource,
    );
    const value = CosAuthorizationEntity.create(response);
    value.resource = resource;

    return value;
  }
}
