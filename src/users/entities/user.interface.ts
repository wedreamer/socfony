import { Field, GraphQLISODateTime, ID, InterfaceType } from '@nestjs/graphql';
import { Prisma } from '@prisma/client';

@InterfaceType()
export class UserInterface
  implements Omit<Prisma.UserGetPayload<{}>, 'phone' | 'email' | 'password'> {
  @Field((type) => ID)
  id: string;

  @Field((type) => String, {
    nullable: true,
  })
  login: string;

  @Field((type) => GraphQLISODateTime)
  createdAt: Date;
}
