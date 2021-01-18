import { NestJS, Kernel } from '~deps';
import { UserWhereUniqueInput } from '../../user';

/**
 * User create Authorization login type.
 */
export enum LoginType {
  PASSWORD,
  PHONE_CODE,
}

// Register enum to GraphQL schema.
NestJS.GraphQL.registerEnumType(LoginType, {
  name: 'LoginType',
  description: 'User login type',
});

/**
 * User create authorization login input.
 */
@NestJS.GraphQL.InputType({
  description: 'User create authorization login input.',
})
export class LoginInput {
  /**
   * Login user where unique input.
   */
  @NestJS.GraphQL.Field((type) => UserWhereUniqueInput, {
    description: 'User where unique input',
  })
  account: Kernel.Prisma.Prisma.UserWhereUniqueInput;

  /**
   * User login type.
   */
  @NestJS.GraphQL.Field((type) => LoginType, {
    description: 'User login type.',
  })
  type: LoginType;

  /**
   * User login password or security code
   */
  @NestJS.GraphQL.Field((type) => String, {
    description: 'User login password or security code',
  })
  encrypted: string;
}
