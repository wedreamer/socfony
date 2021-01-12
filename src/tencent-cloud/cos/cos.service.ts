import { Inject, Injectable } from '@nestjs/common';
import { serviceConfig, ServiceConfig } from 'src/config';
import { alphabetNanoIdGenerator } from 'src/helper';
import { TencentCloudStsService } from '../sts';

@Injectable()
export class TencentCloudCosService {
  constructor(
    private readonly stsService: TencentCloudStsService,
    @Inject(serviceConfig.KEY)
    private readonly serviceConfig: ServiceConfig,
  ) {}

  getOptions() {
    return this.serviceConfig.tencentCloud.cos;
  }

  get temporaryCredentialDurationSeconds() {
    return 7200;
  }

  async createTemporaryReadCredential() {
    const { bucket, region } = this.getOptions();
    const stsClient = this.stsService.createClient(region);
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
    const { bucket, region } = this.getOptions();
    const stsClient = this.stsService.createClient(region);
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
