import { NestJS_GraphQL } from '~deps';
import { AuthDecorator, HasTokenExpiredType, UserDecorator } from '~auth';
import { nanoIdGenerator } from '~core';
import { PrismaClient, User } from '~prisma';
import { UpdateUserProfileInput } from './dto';
import { UserProfileEntity } from './entities';

@NestJS_GraphQL.Resolver((of) => UserProfileEntity)
export class UserProfileResolver {
  constructor(private readonly prisma: PrismaClient) {}

  /**
   * Update user profile data.
   * @param viewer HTTP endpoint authorization user
   * @param data User profile update input data.
   */
  @NestJS_GraphQL.Mutation((returns) => UserProfileEntity, {
    description: 'Update user profile',
  })
  @AuthDecorator({ hasAuthorization: true, type: HasTokenExpiredType.AUTH })
  updateUserProfile(
    @UserDecorator() viewer: User,
    @NestJS_GraphQL.Args({
      name: 'data',
      type: () => UpdateUserProfileInput,
      description: 'User profile update input data',
    })
    data: UpdateUserProfileInput,
  ) {
    return this.prisma.userProfile.upsert({
      where: { userId: viewer.id },
      create: Object.assign({}, data, {
        userId: viewer.id,
        id: nanoIdGenerator(32),
      }),
      update: data,
    });
  }
}
