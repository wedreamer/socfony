import { NestJS } from '~deps';
import { nanoIdGenerator, numberNanoIdGenerator } from '../core';
import { Prisma, PrismaClient, SecurityCode } from '../prisma';
import { TencentCloudShortMessageService } from '../sdk/tencent-cloud';
import {
  securityCodeSmsConfig,
  SecurityCodeSmsConfig,
} from './security-code.config';

/**
 * Security code service.
 */
@NestJS.Common.Injectable()
export class SecurityCodeService {
  constructor(
    private readonly prisma: PrismaClient,
    private readonly smsService: TencentCloudShortMessageService,
    @NestJS.Common.Inject(securityCodeSmsConfig.KEY)
    private readonly smsConfig: SecurityCodeSmsConfig,
  ) {}

  /**
   * Get phone send template options.
   * @param hasChina If `true` get China options.
   */
  getPhoneSecurityCodeOptions(
    hasChina: boolean,
  ): {
    templateId: string;
    veriables: string[];
    expiredIn: number;
  } {
    const { [hasChina ? 'china' : 'other']: value, expiredIn } = this.smsConfig;

    return Object.assign({}, value, { expiredIn });
  }

  /**
   * Send security code to account.
   * @param data Security code create input.
   */
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

  /**
   * Find lts security code for account and code.
   * @param account Sender account.
   * @param code Sent code.
   */
  findFirst(account: string, code: string = undefined) {
    return this.prisma.securityCode.findFirst({
      where: { account, code },
    });
  }

  /**
   * validate security don't expired.
   * @param security security code object.
   */
  async validateSecurity(security: SecurityCode) {
    if (!security || security.disabledAt) return true;
    const { expiredIn } = this.smsConfig;
    const value = (Date.now() - security.createdAt.getTime()) / 1000;
    return value > expiredIn;
  }

  /**
   * disable a security code.
   * @param security security code object.
   */
  async disableSecurity(security: SecurityCode) {
    if (!security || security.disabledAt) return security;
    return await this.prisma.securityCode.update({
      where: { id: security.id },
      data: { disabledAt: new Date() },
    });
  }

  /**
   * Using Tencent Cloud SMS client send security code.
   * @param security security code object.
   */
  private async _sendSecurityCodeForTencentCloud(security: SecurityCode) {
    const setting = this.getPhoneSecurityCodeOptions(
      security.account.startsWith('+86'),
    );
    console.log(setting);
    const params = setting.veriables.map((value) =>
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
