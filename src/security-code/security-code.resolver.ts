import { UseGuards } from '@nestjs/common';
import { Args, Mutation, Resolver } from '@nestjs/graphql';
import { Prisma, User } from '@prisma/client';
import { AuthGuard, UserDecorator } from 'src/authorization';
import { UNAUTHORIZED } from 'src/constants';
import { SendSecurityCodeInput } from './dto';
import { SecurityCodeService } from './security-code.service';

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
    @UserDecorator() userPromise?: Promise<User>,
  ) {
    if (data.validateSender && !userPromise) {
      throw new Error(UNAUTHORIZED);
    } else if (data.validateSender) {
      const user = await userPromise;
      data.sender = {
        connect: { id: user.id },
      };
    }
    this.securityService.send(data);
  }
}
