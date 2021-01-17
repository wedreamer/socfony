import { NestJS_Common, NestJS_GraphQL } from '~deps';
import { AuthGuard, UserDecorator } from '~auth';
import { UNAUTHORIZED } from '~constant';
import { Prisma, User } from '~prisma';
import { SecurityCodeService } from '~security-code';
import { SendSecurityCodeInput } from './dto';

/**
 * Security code sender resolver.
 */
@NestJS_GraphQL.Resolver()
export class SecurityCodeResolver {
  constructor(private readonly securityService: SecurityCodeService) {}

  /**
   * Send security code.
   * @param data Send security code input.
   * @param userPromise The HTTP endpoint `Authorization` code bount user Prisma query client.
   */
  @NestJS_GraphQL.Mutation((returns) => Boolean, {
    nullable: true,
    description: 'Send security code.',
  })
  @NestJS_Common.UseGuards(AuthGuard)
  async sendSecurityCode(
    @NestJS_GraphQL.Args({
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
