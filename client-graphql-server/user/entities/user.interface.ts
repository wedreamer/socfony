import { NestJS_GraphQL } from '~deps';
import { Prisma, UserProfile } from '~prisma';
import { UserProfileEntity } from '../profile';

/**
 * User interface.
 */
@NestJS_GraphQL.InterfaceType({
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
  @NestJS_GraphQL.Field((type) => NestJS_GraphQL.ID, {
    description: 'User ID',
  })
  id: string;

  /**
   * User login name
   */
  @NestJS_GraphQL.Field((type) => String, {
    nullable: true,
    description: 'User login name',
  })
  login: string;

  /**
   * User registered date at.
   */
  @NestJS_GraphQL.Field((type) => NestJS_GraphQL.GraphQLISODateTime, {
    description: 'User registered date at.',
  })
  createdAt: Date;

  /**
   * User profile.
   */
  @NestJS_GraphQL.Field((type) => UserProfileEntity, {
    description: 'The user profile',
  })
  profile: UserProfile;
}
