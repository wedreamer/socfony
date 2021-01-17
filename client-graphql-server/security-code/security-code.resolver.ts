import { UseGuards } from '@nestjs/common';
import { Args, Mutation, Resolver } from '@nestjs/graphql';
import { AuthGuard, UserDecorator } from '~auth';
import { UNAUTHORIZED } from '~constant';
import { Prisma, User } from '~prisma';
import { SecurityCodeService } from '~security-code';
import { SendSecurityCodeInput } from './dto';

/**
 * Security code sender resolver.
 */
@Resolver()
export class SecurityCodeResolver {
  constructor(private readonly securityService: SecurityCodeService) {}

  /**
   * Send security code.
   * @param data Send security code input.
   * @param userPromise The HTTP endpoint `Authorization` code bount user Prisma query client.
   */
  @Mutation((returns) => Boolean, {
    nullable: true,
    description: 'Send security code.',
  })
  @UseGuards(AuthGuard)
  async sendSecurityCode(
    @Args({
      name: 'data',
      type: () => SendSecurityCodeInput,
    })
    data: Prisma.SecurityCodeCreateInput,
    @UserDecorator() user?: User,
  ) {
    if (data.validateSender && !user) {
      throw new Error(UNAUTHORIZED);
    } else if (data.validateSender) {
      data.sender = {
        connect: { id: user.id },
      };
    }
    this.securityService.send(data);
  }
}
