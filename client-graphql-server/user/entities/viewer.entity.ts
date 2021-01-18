import { NestJS, Kernel } from '~deps';
import { UserInterface } from './user.interface';

/**
 * Viewer entity.
 */
@NestJS.GraphQL.ObjectType({
  implements: [UserInterface],
  description: 'Viewer entity.',
})
export class ViewerEntity
  extends UserInterface
  implements Omit<Kernel.Prisma.User, 'password'> {
  /**
   * User bound E-Mail address.
   */
  @NestJS.GraphQL.Field((type) => String, {
    nullable: true,
    description: 'User bound E-Mail address.',
  })
  email: string;

  /**
   * User bound Phone full number.
   */
  @NestJS.GraphQL.Field((type) => String, {
    nullable: true,
    description: 'User bound Phone full number.',
  })
  phone: string;
}
