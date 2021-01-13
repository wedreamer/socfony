import { Field, GraphQLISODateTime, ID, InterfaceType } from '@nestjs/graphql';
import { Prisma } from '@prisma/client';

/**
 * User interface.
 */
@InterfaceType({
  description: 'User interface.',
})
export class UserInterface
  implements Omit<Prisma.UserGetPayload<{}>, 'phone' | 'email' | 'password'> {
  /**
   * User ID
   */
  @Field((type) => ID, {
    description: 'User ID',
  })
  id: string;

  /**
   * User login name
   */
  @Field((type) => String, {
    nullable: true,
    description: 'User login name',
  })
  login: string;

  /**
   * User registered date at.
   */
  @Field((type) => GraphQLISODateTime, {
    description: 'User registered date at.',
  })
  createdAt: Date;
}
