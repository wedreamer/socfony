import { NestJS_GraphQL } from '~deps';
import { User } from '~prisma';
import { UserEntity } from './user.entity';
import { ViewerEntity } from './viewer.entity';
import { AppContext } from '~core';

/**
 * resolve `UserUnion` real type
 * @param value User object.
 * @param context Application context.
 */
async function resolveType(value: User, context: AppContext) {
  if (context.user && context.user.id == value.id) {
    return ViewerEntity;
  }

  return UserEntity;
}

/**
 * User union type.
 */
export const UserUnion = NestJS_GraphQL.createUnionType({
  name: 'userUnion',
  types: () => [UserEntity, ViewerEntity],
  resolveType,
  description: 'User union type.',
});
