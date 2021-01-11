import {
  Args,
  Mutation,
  Parent,
  Query,
  ResolveField,
  Resolver,
} from '@nestjs/graphql';
import { AuthorizationToken, Prisma, PrismaClient } from '@prisma/client';
import { UserUnion } from 'src/users';
import {
  AuthorizationDecorator,
  AuthorizationTokenDecorator,
} from './authorization.decorator';
import { AuthorizationService } from './authorization.service';
import { LoginInput, LoginType } from './dto/login.input';
import { AuthorizationTokenEntity } from './entities/authorization-token.entity';

@Resolver((of) => AuthorizationTokenEntity)
export class AuthorizationResolver {
  constructor(
    private readonly authorizationService: AuthorizationService,
    private readonly prisma: PrismaClient,
  ) {}

  @ResolveField((returns) => UserUnion)
  user(@Parent() authorizationToken: AuthorizationToken) {
    return this.prisma.user.findUnique({
      where: { id: authorizationToken.userId },
    });
  }

  @Mutation((returns) => AuthorizationTokenEntity)
  login(
    @Args({
      name: 'data',
      type: () => LoginInput,
    })
    data: LoginInput,
  ) {
    const { account, type, encrypted } = data;
    if (type === LoginType.PASSWORD) {
      return this.authorizationService.loginWithPassword(account, encrypted);
    }

    return this.authorizationService.loginWithSecurityCode(account, encrypted);
  }

  @Query((returns) => AuthorizationTokenEntity)
  @AuthorizationDecorator({ hasAuthorization: true, type: 'auth' })
  authorization(
    @AuthorizationTokenDecorator()
    client: Prisma.Prisma__AuthorizationTokenClient<AuthorizationToken>,
  ) {
    return client;
  }

  @Mutation((returns) => AuthorizationTokenEntity)
  @AuthorizationDecorator({ hasAuthorization: true, type: 'refresh' })
  refreshAuthorization(
    @AuthorizationTokenDecorator()
    client: Prisma.Prisma__AuthorizationTokenClient<AuthorizationToken>,
  ) {
    return this.authorizationService.refreshAuthorizationToken(client);
  }
}
