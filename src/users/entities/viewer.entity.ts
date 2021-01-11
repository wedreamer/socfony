import { Field, ObjectType } from '@nestjs/graphql';
import { User } from '@prisma/client';
import { UserInterface } from './user.interface';

@ObjectType({
  implements: [UserInterface],
})
export class ViewerEntity
  extends UserInterface
  implements Omit<User, 'password'> {
  @Field((type) => String, {
    nullable: true,
  })
  email: string;

  @Field((type) => String, {
    nullable: true,
  })
  phone: string;
}
