import { NestJS, Kernel } from '~deps';
import { UserInterface } from './entities';
import { UserProfileEntity, UserProfileService } from './profile';

@NestJS.GraphQL.Resolver((of) => UserInterface)
export class UserInterfaceResolver {
  constructor(private readonly userProfileService: UserProfileService) {}

  @NestJS.GraphQL.ResolveField((returns) => UserProfileEntity)
  profile(@NestJS.GraphQL.Parent() parent: Kernel.Prisma.User) {
    return this.userProfileService.resolveProfile(parent);
  }
}
