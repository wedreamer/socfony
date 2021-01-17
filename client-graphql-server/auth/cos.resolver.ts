import { NestJS_GraphQL } from '~deps';
import { AuthDecorator, HasTokenExpiredType } from '~auth';
import { nanoIdGenerator } from '~core';
import { TencentCloudCosService } from '~sdk/tencent-cloud';
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
NestJS_GraphQL.registerEnumType(AllowUploadFileType, {
  name: 'AllowUploadFileType',
  description:
    'Create Tencent Cloud COS write credential allow upload file type.',
});

/**
 * `CosAuthorizationEntity` resolver.
 */
@NestJS_GraphQL.Resolver((of) => CosAuthorizationEntity)
export class CosAuthorizationResolver {
  constructor(private readonly cosService: TencentCloudCosService) {}

  /**
   * Create Tencent Cloud COS temporary read credential.
   */
  @NestJS_GraphQL.Mutation((returns) => CosAuthorizationEntity, {
    description: 'Create Tencent Cloud COS temporary read credential.',
  })
  @AuthDecorator({
    hasAuthorization: true,
    type: HasTokenExpiredType.AUTH,
  })
  async createCosTemporaryReadCredential(): Promise<CosAuthorizationEntity> {
    const response = await this.cosService.createTemporaryReadCredential();
    return CosAuthorizationEntity.create(response);
  }

  /**
   * Create Tencent Cloud COS temporary write credential.
   * @param type Create Tencent Cloud COS write credential allow upload file type.
   */
  @NestJS_GraphQL.Mutation((returns) => CosAuthorizationEntity)
  @AuthDecorator({
    hasAuthorization: true,
    type: HasTokenExpiredType.AUTH,
  })
  async createCosTemporaryWriteCredential(
    @NestJS_GraphQL.Args({
      name: 'type',
      type: () => AllowUploadFileType,
    })
    type: AllowUploadFileType,
  ): Promise<CosAuthorizationEntity> {
    const resource = nanoIdGenerator(64) + type;
    const response = await this.cosService.createTemporaryWriteCredential(
      resource,
    );
    const value = CosAuthorizationEntity.create(response);
    value.resource = resource;

    return value;
  }
}
