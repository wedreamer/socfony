import { NestJS } from '~deps';
import { AuthGuard, UserDecorator } from 'server-kernel/auth';
import { UNAUTHORIZED } from '~constant';
import { Prisma, User } from 'server-kernel/prisma';
import { SecurityCodeService } from 'server-kernel/security-code';
import { SendSecurityCodeInput } from './dto';

/**
 * Security code sender resolver.
 */
@NestJS.GraphQL.Resolver()
export class SecurityCodeResolver {
  constructor(private readonly securityService: SecurityCodeService) {}

  /**
   * Send security code.
   * @param data Send security code input.
   * @param userPromise The HTTP endpoint `Authorization` code bount user Prisma query client.
   */
  @NestJS.GraphQL.Mutation((returns) => Boolean, {
    nullable: true,
    description: 'Send security code.',
  })
  @NestJS.Common.UseGuards(AuthGuard)
  async sendSecurityCode(
    @NestJS.GraphQL.Args({
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
