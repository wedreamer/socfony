import { NestJS } from '~deps';
import { Prisma } from 'server-kernel/prisma';

/**
 * User wherer unique input
 */
@NestJS.GraphQL.InputType({
  description: 'User wherer unique input',
})
export class UserWhereUniqueInput implements Prisma.UserWhereUniqueInput {
  /**
   * User ID.
   */
  @NestJS.GraphQL.Field((type) => NestJS.GraphQL.ID, {
    nullable: true,
    description: 'User ID',
  })
  id?: string;

  /**
   * User login name.
   */
  @NestJS.GraphQL.Field((type) => String, {
    nullable: true,
    description: 'User login name',
  })
  login?: string;

  /**
   * User E-Mail address.
   */
  @NestJS.GraphQL.Field((type) => String, {
    nullable: true,
    description: 'User E-Mail address',
  })
  email?: string;

  /**
   * user phone number.
   */
  @NestJS.GraphQL.Field((type) => NestJS.GraphQL.ID, {
    nullable: true,
    description: 'user phone number',
  })
  phone?: string;
}
