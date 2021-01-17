import { NestJS_GraphQL } from '~deps';
import { ViewerEntity } from '../user';
import {
  AuthDecorator,
  AuthorizationTokenDecorator,
  AuthService,
  HasTokenExpiredType,
} from '~auth';
import { AuthorizationToken, PrismaClient } from '~prisma';
import { LoginInput, LoginType } from './dto';
import { AuthorizationTokenEntity } from './entities';

@NestJS_GraphQL.Resolver((of) => AuthorizationTokenEntity)
export class AuthResolver {
  constructor(
    private readonly authService: AuthService,
    private readonly prisma: PrismaClient,
  ) {}

  /**
   * Resolve `AuthorizationTokenEntity`.`user` field.
   * @param authorizationToken parent object.
   */
  @NestJS_GraphQL.ResolveField((returns) => ViewerEntity)
  user(@NestJS_GraphQL.Parent() authorizationToken: AuthorizationToken) {
    return this.prisma.user.findUnique({
      where: { id: authorizationToken.userId },
    });
  }

  /**
   * User login or using phone register.
   * @param data User create Authorization login type.
   */
  @NestJS_GraphQL.Mutation((returns) => AuthorizationTokenEntity, {
    description: 'User login or using phone register.',
  })
  login(
    @NestJS_GraphQL.Args({
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
  @NestJS_GraphQL.Query((returns) => AuthorizationTokenEntity, {
    description: 'Query HTTP endpoint authorization token entity.',
  })
  @AuthDecorator({ hasAuthorization: true, type: HasTokenExpiredType.AUTH })
  authorization(
    @AuthorizationTokenDecorator()
    token: AuthorizationToken,
  ) {
    return token;
  }

  /**
   * Refresh HTTP endpoint authorization token entity.
   * @param client token query Prisma client.
   */
  @NestJS_GraphQL.Mutation((returns) => AuthorizationTokenEntity, {
    description: 'Refresh HTTP endpoint authorization token entity.',
  })
  @AuthDecorator({ hasAuthorization: true, type: HasTokenExpiredType.REFRESH })
  refreshAuthorization(
    @AuthorizationTokenDecorator()
    token: AuthorizationToken,
  ) {
    return this.authService.refreshAuthorizationToken(token);
  }
}
