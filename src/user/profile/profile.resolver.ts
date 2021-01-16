import { Args, Mutation, Resolver } from '@nestjs/graphql';
import { PrismaClient, User } from '@prisma/client';
import {
  AuthorizationDecorator,
  UserDecorator,
} from 'src/authorization/authorization.decorator';
import { nanoIdGenerator } from 'src/helper';
import { UpdateUserProfileInput } from './dto';
import { UserProfileEntity } from './entities';

@Resolver((of) => UserProfileEntity)
export class UserProfileResolver {
  constructor(private readonly prisma: PrismaClient) {}

  /**
   * Update user profile data.
   * @param viewer HTTP endpoint authorization user
   * @param data User profile update input data.
   */
  @Mutation((returns) => UserProfileEntity, {
    description: 'Update user profile',
  })
  @AuthorizationDecorator({ hasAuthorization: true, type: 'auth' })
  updateUserProfile(
    @UserDecorator() viewer: User,
    @Args({
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
