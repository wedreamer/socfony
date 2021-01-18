import { NestJS, Kernel } from '~deps';
import { UpdateUserProfileInput } from './dto';
import { UserProfileEntity } from './entities';

@NestJS.GraphQL.Resolver((of) => UserProfileEntity)
export class UserProfileResolver {
  constructor(private readonly prisma: Kernel.Prisma.PrismaClient) {}

  /**
   * Update user profile data.
   * @param viewer HTTP endpoint authorization user
   * @param data User profile update input data.
   */
  @NestJS.GraphQL.Mutation((returns) => UserProfileEntity, {
    description: 'Update user profile',
  })
  @Kernel.Auth.AuthDecorator({
    hasAuthorization: true,
    type: Kernel.Auth.HasTokenExpiredType.AUTH,
  })
  updateUserProfile(
    @Kernel.Auth.UserDecorator() viewer: Kernel.Prisma.User,
    @NestJS.GraphQL.Args({
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
        id: Kernel.Core.nanoIdGenerator(32),
      }),
      update: data,
    });
  }
}
