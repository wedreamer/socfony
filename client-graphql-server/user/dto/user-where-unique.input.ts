import { NestJS_GraphQL } from '~deps';
import { Prisma } from '~prisma';

/**
 * User wherer unique input
 */
@NestJS_GraphQL.InputType({
  description: 'User wherer unique input',
})
export class UserWhereUniqueInput implements Prisma.UserWhereUniqueInput {
  /**
   * User ID.
   */
  @NestJS_GraphQL.Field((type) => NestJS_GraphQL.ID, {
    nullable: true,
    description: 'User ID',
  })
  id?: string;

  /**
   * User login name.
   */
  @NestJS_GraphQL.Field((type) => String, {
    nullable: true,
    description: 'User login name',
  })
  login?: string;

  /**
   * User E-Mail address.
   */
  @NestJS_GraphQL.Field((type) => String, {
    nullable: true,
    description: 'User E-Mail address',
  })
  email?: string;

  /**
   * user phone number.
   */
  @NestJS_GraphQL.Field((type) => NestJS_GraphQL.ID, {
    nullable: true,
    description: 'user phone number',
  })
  phone?: string;
}
