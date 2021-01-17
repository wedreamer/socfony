import { NestJS_GraphQL } from '~deps';
import { UserInterface } from './user.interface';

/**
 * User entity.
 */
@NestJS_GraphQL.ObjectType({
  implements: [UserInterface],
  description: 'User entity',
})
export class UserEntity extends UserInterface {}
