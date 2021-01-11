import { Injectable } from '@nestjs/common';
import { Prisma, PrismaClient, SecurityCode } from '@prisma/client';
import { nanoIdGenerator, numberNanoIdGenerator } from 'src/helper';
import { TencentCloudShortMessageService } from 'src/tencent-cloud';

@Injectable()
export class SecurityCodeService {
  constructor(
    private readonly prisma: PrismaClient,
    private readonly smsService: TencentCloudShortMessageService,
  ) {}

  async getPhoneSecurityCodeOptions(): Promise<{
    templateId: string;
    args: string[];
    expiredIn: number;
  }> {
    const setting = await this.prisma.setting.findUnique({
      where: {
        namespace_name: {
          namespace: 'tencent-cloud',
          name: 'security-code',
        },
      },
    });
    const value = setting?.value as any;
    const { templateId, args = ['#code#', '#expired#'], expiredIn = 300 } =
      value || {};

    return { templateId, args, expiredIn };
  }

  async send(
    data: Omit<
      Prisma.SecurityCodeCreateInput,
      'id' | 'createdAt' | 'response' | 'code'
    >,
  ) {
    const security = await this.prisma.securityCode.create({
      data: {
        ...data,
        id: nanoIdGenerator(32),
        code: numberNanoIdGenerator(6),
      },
    });
    this._sendSecurityCodeForTencentCloud(security);

    return security;
  }

  private async _sendSecurityCodeForTencentCloud(security: SecurityCode) {
    const setting = await this.getPhoneSecurityCodeOptions();
    const params = setting.args.map((value) =>
      value
        .replace('#code#', security.code)
        .replace('#expired#', (setting.expiredIn / 60).toFixed(0)),
    );
    let result: any;
    try {
      result = await this.smsService.send({
        PhoneNumberSet: [security.account],
        TemplateID: setting.templateId,
        TemplateParamSet: params,
      });
    } catch (e) {
      result = e;
    }

    await this.prisma.securityCode.update({
      where: { id: security.id },
      data: {
        response: result,
      },
    });
  }
}
