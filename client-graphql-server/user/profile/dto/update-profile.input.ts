import { NestJS_GraphQL } from '~deps';
import { Prisma } from '~prisma';

@NestJS_GraphQL.InputType()
export class UpdateUserProfileInput
  implements Omit<Prisma.UserProfileUpdateInput, 'id' | 'updatedAt' | 'user'> {
  @NestJS_GraphQL.Field((type) => String, {
    description: 'User name.',
    nullable: true,
    defaultValue: undefined,
  })
  name?: string;

  @NestJS_GraphQL.Field((type) => String, {
    description: 'User avatar storage path.',
    nullable: true,
    defaultValue: undefined,
  })
  avatar?: string;

  @NestJS_GraphQL.Field((type) => String, {
    description: 'User licartion string.',
    nullable: true,
    defaultValue: undefined,
  })
  location?: string;

  @NestJS_GraphQL.Field((type) => String, {
    description: 'User bio.',
    nullable: true,
    defaultValue: undefined,
  })
  bio?: string;
}
