import { NestJS, Kernel } from '~deps';
import { UserEntity } from './user.entity';
import { ViewerEntity } from './viewer.entity';

/**
 * resolve `UserUnion` real type
 * @param value User object.
 * @param context Application context.
 */
async function resolveType(
  value: Kernel.Prisma.User,
  context: Kernel.Core.AppContext,
) {
  if (context.user && context.user.id == value.id) {
    return ViewerEntity;
  }

  return UserEntity;
}

/**
 * User union type.
 */
export const UserUnion = NestJS.GraphQL.createUnionType({
  name: 'userUnion',
  types: () => [UserEntity, ViewerEntity],
  resolveType,
  description: 'User union type.',
});
