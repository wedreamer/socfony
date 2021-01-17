import { NestJS_GraphQL } from '~deps';
import { ViewerEntity } from '../../user';
import { Prisma, User } from '~prisma';

/**
 * HTTP endpoint authorization entity.
 */
@NestJS_GraphQL.ObjectType({
  description: 'HTTP endpoint authorization entity.',
})
export class AuthorizationTokenEntity
  implements
    Prisma.AuthorizationTokenGetPayload<{
      include: {
        user: false;
      };
    }> {
  /**
   * Logged user id.
   */
  @NestJS_GraphQL.Field((type) => NestJS_GraphQL.ID, {
    description: 'Login user ID',
  })
  userId: string;

  /**
   * Logged User
   */
  @NestJS_GraphQL.Field((type) => ViewerEntity, {
    description: 'Logged Viewer entity',
  })
  user: User;

  /**
   * User API endpoit authorization token.
   */
  @NestJS_GraphQL.Field((type) => String, {
    description: 'User API endpoit authorization token.',
  })
  token: string;

  /**
   * Token expired date.
   */
  @NestJS_GraphQL.Field((type) => Date, {
    description: 'Token expired date',
  })
  expiredAt: Date;

  /**
   * Token on refresh expired date.
   */
  @NestJS_GraphQL.Field((type) => Date, {
    description: 'Token on refresh expired date',
  })
  refreshExpiredAt: Date;
}
