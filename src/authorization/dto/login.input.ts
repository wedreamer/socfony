import { Field, InputType, registerEnumType } from '@nestjs/graphql';
import { Prisma } from '@prisma/client';
import { UserWhereUniqueInput } from 'src/users/dto/user-where-unique.input';

export enum LoginType {
  PASSWORD,
  PHONE_CODE,
}
registerEnumType(LoginType, {
  name: 'LoginType',
  description: 'User login type',
});

@InputType()
export class LoginInput {
  @Field((type) => UserWhereUniqueInput, {
    description: 'User where unique input',
  })
  account: Prisma.UserWhereUniqueInput;

  @Field((type) => LoginType, {
    description: 'User login type.',
  })
  type: LoginType;

  @Field((type) => String, {
    description: 'Encrypted password or code',
  })
  encrypted: string;
}
