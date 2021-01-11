import { UseGuards } from '@nestjs/common';
import { Args, Mutation, Resolver } from '@nestjs/graphql';
import { Prisma, PrismaClient, User } from '@prisma/client';
import { AuthGuard, UserDecorator } from 'src/authorization';
import { UNAUTHENTICATION } from 'src/constants';
import { SendSecurityCodeInput } from './dto';
import { SecurityCodeService } from './security-code.service';

@Resolver()
export class SecurityCodeResolver {
  constructor(
    private readonly prisma: PrismaClient,
    private readonly securityService: SecurityCodeService,
  ) {}

  @Mutation((returns) => Boolean, {
    nullable: true,
    description: '发送验证码',
    name: 'sendSecurityCode',
  })
  @UseGuards(AuthGuard)
  async send(
    @Args({
      name: 'data',
      type: () => SendSecurityCodeInput,
    })
    data: Prisma.SecurityCodeCreateInput,
    @UserDecorator() userPromise?: Promise<User>,
  ) {
    if (data.validateSender && !userPromise) {
      throw new Error(UNAUTHENTICATION);
    } else if (data.validateSender) {
      const user = await userPromise;
      data.sender = {
        connect: { id: user.id },
      };
    }
    this.securityService.send(data);
  }
}
