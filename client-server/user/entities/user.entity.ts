import { NestJS } from '~deps';
import { UserInterface } from './user.interface';

/**
 * User entity.
 */
@NestJS.GraphQL.ObjectType({
  implements: [UserInterface],
  description: 'User entity',
})
export class UserEntity extends UserInterface {}
