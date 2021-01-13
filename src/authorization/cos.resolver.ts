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
registerEnumType(AllowUploadFileType, {
  name: 'AllowUploadFileType',
});

@Resolver((of) => CosAuthorizationEntity)
export class CosAuthorizationResolver {
  constructor(private readonly cosService: TencentCloudCosService) {}

  @Mutation((returns) => CosAuthorizationEntity)
  @AuthorizationDecorator({
    hasAuthorization: true,
    type: 'auth',
  })
  async createCosTemporaryReadCredential(): Promise<CosAuthorizationEntity> {
    const response = await this.cosService.createTemporaryReadCredential();
    return CosAuthorizationEntity.create(response);
  }

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
    const response = await this.cosService.createTemporaryWriteCredential(
      nanoIdGenerator(64) + type,
    );
    return CosAuthorizationEntity.create(response);
  }
}
