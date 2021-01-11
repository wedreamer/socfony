import { Field, InputType } from '@nestjs/graphql';
import { SecurityCode } from '@prisma/client';

@InputType()
export class SendSecurityCodeInput
  implements Pick<SecurityCode, 'validateSender' | 'account'> {
  @Field((type) => String, {
    description: '需要发送到的账户',
  })
  account: string;

  @Field((type) => Boolean, {
    description: '验证码发送场景是否要验证发送者（即验证是否登陆）',
  })
  validateSender: boolean;
}
