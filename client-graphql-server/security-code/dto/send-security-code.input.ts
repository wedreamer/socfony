import { NestJS } from '~deps';
import { SecurityCode } from 'server-kernel/prisma';

/**
 * Send security code input.
 */
@NestJS.GraphQL.InputType({
  description: 'Send security code input.',
})
export class SendSecurityCodeInput
  implements Pick<SecurityCode, 'validateSender' | 'account'> {
  /**
   * Need send security code account.
   */
  @NestJS.GraphQL.Field((type) => String, {
    description: 'Need send security code account.',
  })
  account: string;

  /**
   * Has sent security code need validate sender.
   */
  @NestJS.GraphQL.Field((type) => Boolean, {
    description: 'Has sent security code need validate sender.',
  })
  validateSender: boolean;
}
