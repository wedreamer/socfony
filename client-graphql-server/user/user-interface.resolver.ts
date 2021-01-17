import { NestJS } from '~deps';
import { User } from 'server-kernel/prisma';
import { UserInterface } from './entities';
import { UserProfileEntity, UserProfileService } from './profile';

@NestJS.GraphQL.Resolver((of) => UserInterface)
export class UserInterfaceResolver {
  constructor(private readonly userProfileService: UserProfileService) {}

  @NestJS.GraphQL.ResolveField((returns) => UserProfileEntity)
  profile(@NestJS.GraphQL.Parent() parent: User) {
    return this.userProfileService.resolveProfile(parent);
  }
}
