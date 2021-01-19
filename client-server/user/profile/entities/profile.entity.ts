import { NestJS, Kernel } from '~deps';

@NestJS.GraphQL.ObjectType()
export class UserProfileEntity implements Kernel.Prisma.UserProfile {
  @NestJS.GraphQL.Field((type) => NestJS.GraphQL.ID, {
    description: 'User profile ID',
  })
  id: string;

  @NestJS.GraphQL.Field((type) => NestJS.GraphQL.ID, {
    description: 'Profile owner ID',
  })
  userId: string;

  @NestJS.GraphQL.Field((type) => String, {
    description: 'User name.',
    nullable: true,
  })
  name: string;

  @NestJS.GraphQL.Field((type) => String, {
    description: 'User avatar storage path.',
    nullable: true,
  })
  avatar: string;

  @NestJS.GraphQL.Field((type) => String, {
    description: 'User bio.',
    nullable: true,
  })
  bio: string;

  @NestJS.GraphQL.Field((type) => String, {
    description: 'User location string.',
    nullable: true,
  })
  location: string;

  @NestJS.GraphQL.Field((type) => NestJS.GraphQL.GraphQLISODateTime, {
    description: 'User profile updated at.',
    nullable: true,
  })
  updatedAt: Date;
}
