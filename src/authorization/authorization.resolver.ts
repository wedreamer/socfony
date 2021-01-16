import {
  Args,
  Mutation,
  Parent,
  Query,
  ResolveField,
  Resolver,
} from '@nestjs/graphql';
import { AuthorizationToken, Prisma, PrismaClient } from '@prisma/client';
import { ViewerEntity } from 'src/user';
import {
  AuthorizationDecorator,
  AuthorizationTokenDecorator,
} from './authorization.decorator';
import { AuthorizationService } from './authorization.service';
import { LoginInput, LoginType } from './dto/login.input';
import { AuthorizationTokenEntity } from './entities/authorization-token.entity';

/**
 * `AuthorizationTokenEntity` GraphQL resolver.
 */
@Resolver((of) => AuthorizationTokenEntity)
export class AuthorizationResolver {
  constructor(
    private readonly authorizationService: AuthorizationService,
    private readonly prisma: PrismaClient,
  ) {}

  /**
   * Resolve `AuthorizationTokenEntity`.`user` field.
   * @param authorizationToken parent object.
   */
  @ResolveField((returns) => ViewerEntity)
  user(@Parent() authorizationToken: AuthorizationToken) {
    return this.prisma.user.findUnique({
      where: { id: authorizationToken.userId },
    });
  }

  /**
   * User login or using phone register.
   * @param data User create Authorization login type.
   */
  @Mutation((returns) => AuthorizationTokenEntity, {
    description: 'User login or using phone register.',
  })
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

  /**
   * Query HTTP endpoint authorization token entity.
   * @param client token query Prisma client.
   */
  @Query((returns) => AuthorizationTokenEntity, {
    description: 'Query HTTP endpoint authorization token entity.',
  })
  @AuthorizationDecorator({ hasAuthorization: true, type: 'auth' })
  authorization(
    @AuthorizationTokenDecorator()
    client: Prisma.Prisma__AuthorizationTokenClient<AuthorizationToken>,
  ) {
    return client;
  }

  /**
   * Refresh HTTP endpoint authorization token entity.
   * @param client token query Prisma client.
   */
  @Mutation((returns) => AuthorizationTokenEntity, {
    description: 'Refresh HTTP endpoint authorization token entity.',
  })
  @AuthorizationDecorator({ hasAuthorization: true, type: 'refresh' })
  refreshAuthorization(
    @AuthorizationTokenDecorator()
    client: Prisma.Prisma__AuthorizationTokenClient<AuthorizationToken>,
  ) {
    return this.authorizationService.refreshAuthorizationToken(client);
  }
}
