import { NestJS, Kernel } from '~deps';
import { ViewerEntity } from '../../user';

/**
 * HTTP endpoint authorization entity.
 */
@NestJS.GraphQL.ObjectType({
  description: 'HTTP endpoint authorization entity.',
})
export class AuthorizationTokenEntity
  implements
    Kernel.Prisma.Prisma.AuthorizationTokenGetPayload<{
      include: {
        user: false;
      };
    }> {
  /**
   * Logged user id.
   */
  @NestJS.GraphQL.Field((type) => NestJS.GraphQL.ID, {
    description: 'Login user ID',
  })
  userId: string;

  /**
   * Logged User
   */
  @NestJS.GraphQL.Field((type) => ViewerEntity, {
    description: 'Logged Viewer entity',
  })
  user: Kernel.Prisma.User;

  /**
   * User API endpoit authorization token.
   */
  @NestJS.GraphQL.Field((type) => String, {
    description: 'User API endpoit authorization token.',
  })
  token: string;

  /**
   * Token expired date.
   */
  @NestJS.GraphQL.Field((type) => Date, {
    description: 'Token expired date',
  })
  expiredAt: Date;

  /**
   * Token on refresh expired date.
   */
  @NestJS.GraphQL.Field((type) => Date, {
    description: 'Token on refresh expired date',
  })
  refreshExpiredAt: Date;
}
