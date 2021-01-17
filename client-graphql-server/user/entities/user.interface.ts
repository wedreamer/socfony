import { NestJS } from '~deps';
import { Prisma, UserProfile } from 'server-kernel/prisma';
import { UserProfileEntity } from '../profile';

/**
 * User interface.
 */
@NestJS.GraphQL.InterfaceType({
  description: 'User interface.',
})
export class UserInterface
  implements
    Omit<
      Prisma.UserGetPayload<{
        include: {
          profile: true;
        };
      }>,
      'phone' | 'email' | 'password'
    > {
  /**
   * User ID
   */
  @NestJS.GraphQL.Field((type) => NestJS.GraphQL.ID, {
    description: 'User ID',
  })
  id: string;

  /**
   * User login name
   */
  @NestJS.GraphQL.Field((type) => String, {
    nullable: true,
    description: 'User login name',
  })
  login: string;

  /**
   * User registered date at.
   */
  @NestJS.GraphQL.Field((type) => NestJS.GraphQL.GraphQLISODateTime, {
    description: 'User registered date at.',
  })
  createdAt: Date;

  /**
   * User profile.
   */
  @NestJS.GraphQL.Field((type) => UserProfileEntity, {
    description: 'The user profile',
  })
  profile: UserProfile;
}
