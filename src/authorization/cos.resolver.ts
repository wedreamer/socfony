import { Args, Mutation, registerEnumType, Resolver } from '@nestjs/graphql';
import { nanoIdGenerator } from 'src/helper';
import { TencentCloudCosService } from 'src/tencent-cloud';
import { AuthorizationDecorator } from './authorization.decorator';
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
registerEnumType(AllowUploadFileType, {
  name: 'AllowUploadFileType',
  description:
    'Create Tencent Cloud COS write credential allow upload file type.',
});

/**
 * `CosAuthorizationEntity` resolver.
 */
@Resolver((of) => CosAuthorizationEntity)
export class CosAuthorizationResolver {
  constructor(private readonly cosService: TencentCloudCosService) {}

  /**
   * Create Tencent Cloud COS temporary read credential.
   */
  @Mutation((returns) => CosAuthorizationEntity, {
    description: 'Create Tencent Cloud COS temporary read credential.',
  })
  @AuthorizationDecorator({
    hasAuthorization: true,
    type: 'auth',
  })
  async createCosTemporaryReadCredential(): Promise<CosAuthorizationEntity> {
    const response = await this.cosService.createTemporaryReadCredential();
    return CosAuthorizationEntity.create(response);
  }

  /**
   * Create Tencent Cloud COS temporary write credential.
   * @param type Create Tencent Cloud COS write credential allow upload file type.
   */
  @Mutation((returns) => CosAuthorizationEntity)
  @AuthorizationDecorator({
    hasAuthorization: true,
    type: 'auth',
  })
  async createCosTemporaryWriteCredential(
    @Args({
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
