import { NestJS_GraphQL } from '~deps';
import { User } from '~prisma';
import { UserInterface } from './entities';
import { UserProfileEntity, UserProfileService } from './profile';

@NestJS_GraphQL.Resolver((of) => UserInterface)
export class UserInterfaceResolver {
  constructor(private readonly userProfileService: UserProfileService) {}

  @NestJS_GraphQL.ResolveField((returns) => UserProfileEntity)
  profile(@NestJS_GraphQL.Parent() parent: User) {
    return this.userProfileService.resolveProfile(parent);
  }
}
