import { NestJS_GraphQL } from '~deps';
import { UserWhereUniqueInput } from '../../user';
import { Prisma } from '~prisma';

/**
 * User create Authorization login type.
 */
export enum LoginType {
  PASSWORD,
  PHONE_CODE,
}

// Register enum to GraphQL schema.
NestJS_GraphQL.registerEnumType(LoginType, {
  name: 'LoginType',
  description: 'User login type',
});

/**
 * User create authorization login input.
 */
@NestJS_GraphQL.InputType({
  description: 'User create authorization login input.',
})
export class LoginInput {
  /**
   * Login user where unique input.
   */
  @NestJS_GraphQL.Field((type) => UserWhereUniqueInput, {
    description: 'User where unique input',
  })
  account: Prisma.UserWhereUniqueInput;

  /**
   * User login type.
   */
  @NestJS_GraphQL.Field((type) => LoginType, {
    description: 'User login type.',
  })
  type: LoginType;

  /**
   * User login password or security code
   */
  @NestJS_GraphQL.Field((type) => String, {
    description: 'User login password or security code',
  })
  encrypted: string;
}
