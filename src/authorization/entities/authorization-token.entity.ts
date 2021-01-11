import { Field, ID, ObjectType } from '@nestjs/graphql';
import { Prisma, User } from '@prisma/client';
import { ViewerEntity } from 'src/users';

@ObjectType()
export class AuthorizationTokenEntity
  implements
    Prisma.AuthorizationTokenGetPayload<{
      include: {
        user: true;
      };
    }> {
  @Field((type) => ID, {
    description: 'Login user ID',
  })
  userId: string;

  @Field((type) => ViewerEntity)
  user: User;

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
