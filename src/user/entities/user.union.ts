import { createUnionType } from '@nestjs/graphql';
import { User } from '@prisma/client';
import { AppExecutionContext } from 'src/global';
import { UserEntity } from './user.entity';
import { ViewerEntity } from './viewer.entity';

/**
 * resolve `UserUnion` real type
 * @param value User object.
 * @param context Application context.
 */
async function resolveType(
  value: User,
  context: AppExecutionContext & { cachedUser: User },
) {
  if (context.cachedUser && context.cachedUser.id == value.id) {
    return ViewerEntity;
  }
  context.cachedUser = await context?.userClient();
  if (context.cachedUser) {
    return resolveType(value, context);
  }

  return UserEntity;
}

/**
 * User union type.
 */
export const UserUnion = createUnionType({
  name: 'userUnion',
  types: () => [UserEntity, ViewerEntity],
  resolveType,
  description: 'User union type.',
});
