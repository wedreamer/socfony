import { Field, ID, ObjectType } from '@nestjs/graphql';
import { Prisma, User } from '@prisma/client';

@ObjectType()
export class AuthorizationTokenEntity
  implements
    Prisma.AuthorizationTokenGetPayload<{
      include: {
        user: false;
      };
    }> {
  @Field((type) => ID, {
    description: 'Login user ID',
  })
  userId: string;

  @Field((type) => String, {
    description: 'Login Token',
  })
  token: string;

  @Field((type) => Date, {
    description: 'Token expired date',
  })
  expiredAt: Date;

  @Field((type) => Date, {
    description: 'Token on refresh expired date',
  })
  refreshExpiredAt: Date;
}
