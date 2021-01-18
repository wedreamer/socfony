import { NestJS, Kernel } from '~deps';
import { UNAUTHORIZED } from '~constant';
import { SendSecurityCodeInput } from './dto';

/**
 * Security code sender resolver.
 */
@NestJS.GraphQL.Resolver()
export class SecurityCodeResolver {
  constructor(
    private readonly securityService: Kernel.SecurityCode.SecurityCodeService,
  ) {}

  /**
   * Send security code.
   * @param data Send security code input.
   * @param userPromise The HTTP endpoint `Authorization` code bount user Prisma query client.
   */
  @NestJS.GraphQL.Mutation((returns) => Boolean, {
    nullable: true,
    description: 'Send security code.',
  })
  @Kernel.Auth.AuthDecorator({
    hasAuthorization: false,
    type: Kernel.Auth.HasTokenExpiredType.AUTH,
  })
  async sendSecurityCode(
    @NestJS.GraphQL.Args({
      name: 'data',
      type: () => SendSecurityCodeInput,
    })
    data: Kernel.Prisma.Prisma.SecurityCodeCreateInput,
    @Kernel.Auth.UserDecorator() user?: Kernel.Prisma.User,
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
