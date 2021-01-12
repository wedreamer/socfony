import { Injectable } from '@nestjs/common';
import { PrismaClient } from '@prisma/client';
import { alphabetNanoIdGenerator } from 'src/helper';
import { TencentCloudStsService } from '../sts';

@Injectable()
export class TencentCloudCosService {
  constructor(
    private readonly stsService: TencentCloudStsService,
    private readonly prisma: PrismaClient,
  ) {}

  async getOptions(): Promise<{
    bucket: string;
    region: string;
  }> {
    const setting = await this.prisma.setting.findUnique({
      where: {
        namespace_name: {
          name: 'cos',
          namespace: 'tencent-cloud',
        },
      },
    });

    return setting?.value as any;
  }

  get temporaryCredentialDurationSeconds() {
    return 7200;
  }

  async createTemporaryReadCredential() {
    const { bucket, region } = await this.getOptions();
    const stsClient = await this.stsService.createClient(region);
    const [_, uid] = bucket.split('-');
    return await stsClient.GetFederationToken({
      Name: alphabetNanoIdGenerator(32),
      DurationSeconds: this.temporaryCredentialDurationSeconds,
      Policy: JSON.stringify({
        version: '2.0',
        statement: [
          {
            effect: 'allow',
            action: [
              'name/cos:GetObject',
              'name/cos:HeadObject',
              'name/cos:OptionsObject',
            ],
            resource: [`qcs:cos:${region}/uid/${uid}:${bucket}/*`],
          },
        ],
      }),
    });
  }

  async createTemporaryWriteCredential(name: string) {
    const { bucket, region } = await this.getOptions();
    const stsClient = await this.stsService.createClient(region);
    const [_, uid] = bucket.split('-');
    return await stsClient.GetFederationToken({
      Name: alphabetNanoIdGenerator(32),
      DurationSeconds: this.temporaryCredentialDurationSeconds,
      Policy: JSON.stringify({
        version: '2.0',
        statement: [
          {
            effect: 'allow',
            action: [
              //简单上传操作
              'name/cos:PutObject',
              //表单上传对象
              'name/cos:PostObject',
              //分块上传：初始化分块操作
              'name/cos:InitiateMultipartUpload',
              //分块上传：List 进行中的分块上传
              'name/cos:ListMultipartUploads',
              //分块上传：List 已上传分块操作
              'name/cos:ListParts',
              //分块上传：上传分块块操作
              'name/cos:UploadPart',
              //分块上传：完成所有分块上传操作
              'name/cos:CompleteMultipartUpload',
              //取消分块上传操作
              'name/cos:AbortMultipartUpload',
            ],
            resource: [`qcs:cos:${region}/uid/${uid}:${bucket}/${name}`],
          },
        ],
      }),
    });
  }
}
