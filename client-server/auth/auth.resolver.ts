import { NestJS, Kernel } from '~deps';
import { ViewerEntity } from '../user';
import { LoginInput, LoginType } from './dto';
import { AuthorizationTokenEntity } from './entities';

@NestJS.GraphQL.Resolver((of) => AuthorizationTokenEntity)
export class AuthResolver {
  constructor(
    private readonly authService: Kernel.Auth.AuthService,
    private readonly prisma: Kernel.Prisma.PrismaClient,
  ) {}

  /**
   * Resolve `AuthorizationTokenEntity`.`user` field.
   * @param authorizationToken parent object.
   */
  @NestJS.GraphQL.ResolveField((returns) => ViewerEntity)
  user(
    @NestJS.GraphQL.Parent()
    authorizationToken: Kernel.Prisma.AuthorizationToken,
  ) {
    return this.prisma.user.findUnique({
      where: { id: authorizationToken.userId },
    });
  }

  /**
   * User login or using phone register.
   * @param data User create Authorization login type.
   */
  @NestJS.GraphQL.Mutation((returns) => AuthorizationTokenEntity, {
    description: 'User login or using phone register.',
  })
  login(
    @NestJS.GraphQL.Args({
      name: 'data',
      type: () => LoginInput,
    })
    data: LoginInput,
  ) {
    const { account, type, encrypted } = data;
    if (type === LoginType.PASSWORD) {
      return this.authService.loginWithPassword(account, encrypted);
    }

    return this.authService.loginWithSecurityCode(account, encrypted);
  }

  /**
   * Query HTTP endpoint authorization token entity.
   * @param client token query Prisma client.
   */
  @NestJS.GraphQL.Query((returns) => AuthorizationTokenEntity, {
    description: 'Query HTTP endpoint authorization token entity.',
  })
  @Kernel.Auth.AuthDecorator({
    hasAuthorization: true,
    type: Kernel.Auth.HasTokenExpiredType.AUTH,
  })
  authorization(
    @Kernel.Auth.AuthorizationTokenDecorator()
    token: Kernel.Prisma.AuthorizationToken,
  ) {
    return token;
  }

  /**
   * Refresh HTTP endpoint authorization token entity.
   * @param client token query Prisma client.
   */
  @NestJS.GraphQL.Mutation((returns) => AuthorizationTokenEntity, {
    description: 'Refresh HTTP endpoint authorization token entity.',
  })
  @Kernel.Auth.AuthDecorator({
    hasAuthorization: true,
    type: Kernel.Auth.HasTokenExpiredType.REFRESH,
  })
  refreshAuthorization(
    @Kernel.Auth.AuthorizationTokenDecorator()
    token: Kernel.Prisma.AuthorizationToken,
  ) {
    return this.authService.refreshAuthorizationToken(token);
  }
}
