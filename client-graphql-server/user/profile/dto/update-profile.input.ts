import { NestJS } from '~deps';
import { Prisma } from 'server-kernel/prisma';

@NestJS.GraphQL.InputType()
export class UpdateUserProfileInput
  implements Omit<Prisma.UserProfileUpdateInput, 'id' | 'updatedAt' | 'user'> {
  @NestJS.GraphQL.Field((type) => String, {
    description: 'User name.',
    nullable: true,
    defaultValue: undefined,
  })
  name?: string;

  @NestJS.GraphQL.Field((type) => String, {
    description: 'User avatar storage path.',
    nullable: true,
    defaultValue: undefined,
  })
  avatar?: string;

  @NestJS.GraphQL.Field((type) => String, {
    description: 'User licartion string.',
    nullable: true,
    defaultValue: undefined,
  })
  location?: string;

  @NestJS.GraphQL.Field((type) => String, {
    description: 'User bio.',
    nullable: true,
    defaultValue: undefined,
  })
  bio?: string;
}
