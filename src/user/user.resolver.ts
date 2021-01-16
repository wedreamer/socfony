import { Query, Resolver } from '@nestjs/graphql';
import { User } from '@prisma/client';
import { AuthorizationDecorator, UserDecorator } from 'src/authorization';
import { UserEntity } from './entities';

@Resolver((of) => UserEntity)
export class UserResolver {
  @Query((returns) => Boolean)
  @AuthorizationDecorator({ hasAuthorization: true })
  demo(@UserDecorator() user: User) {
    console.log(user);
    return user instanceof Promise;
  }
}
