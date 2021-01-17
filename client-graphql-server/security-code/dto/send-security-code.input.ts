import { NestJS_GraphQL } from '~deps';
import { SecurityCode } from '~prisma';

/**
 * Send security code input.
 */
@NestJS_GraphQL.InputType({
  description: 'Send security code input.',
})
export class SendSecurityCodeInput
  implements Pick<SecurityCode, 'validateSender' | 'account'> {
  /**
   * Need send security code account.
   */
  @NestJS_GraphQL.Field((type) => String, {
    description: 'Need send security code account.',
  })
  account: string;

  /**
   * Has sent security code need validate sender.
   */
  @NestJS_GraphQL.Field((type) => Boolean, {
    description: 'Has sent security code need validate sender.',
  })
  validateSender: boolean;
}
