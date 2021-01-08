import { Field, ID, InputType } from '@nestjs/graphql';
import { Prisma } from '@prisma/client';

@InputType({
  description: 'User wherer unique input',
})
export class UserWhereUniqueInput implements Prisma.UserWhereUniqueInput {
  @Field((type) => ID, {
    nullable: true,
    description: 'User ID',
  })
  id?: string;

  @Field((type) => String, {
    nullable: true,
    description: 'User login name',
  })
  login?: string;

  @Field((type) => String, {
    nullable: true,
    description: 'User E-Mail address',
  })
  email?: string;

  @Field((type) => ID, {
    nullable: true,
    description: 'user phone number',
  })
  phone?: string;
}
