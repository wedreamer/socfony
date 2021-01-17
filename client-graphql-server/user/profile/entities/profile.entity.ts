import { NestJS_GraphQL } from '~deps';
import { UserProfile } from '~prisma';

@NestJS_GraphQL.ObjectType()
export class UserProfileEntity implements UserProfile {
  @NestJS_GraphQL.Field((type) => NestJS_GraphQL.ID, {
    description: 'User profile ID',
  })
  id: string;

  @NestJS_GraphQL.Field((type) => NestJS_GraphQL.ID, {
    description: 'Profile owner ID',
  })
  userId: string;

  @NestJS_GraphQL.Field((type) => String, {
    description: 'User name.',
    nullable: true,
  })
  name: string;

  @NestJS_GraphQL.Field((type) => String, {
    description: 'User avatar storage path.',
    nullable: true,
  })
  avatar: string;

  @NestJS_GraphQL.Field((type) => String, {
    description: 'User bio.',
    nullable: true,
  })
  bio: string;

  @NestJS_GraphQL.Field((type) => String, {
    description: 'User location string.',
    nullable: true,
  })
  location: string;

  @NestJS_GraphQL.Field((type) => NestJS_GraphQL.GraphQLISODateTime, {
    description: 'User profile updated at.',
    nullable: true,
  })
  updatedAt: Date;
}
