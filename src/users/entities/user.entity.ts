import { ObjectType } from '@nestjs/graphql';
import { UserInterface } from './user.interface';

@ObjectType({
  implements: [UserInterface],
})
export class UserEntity extends UserInterface {}
