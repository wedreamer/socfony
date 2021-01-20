import { Parent, ResolveField, Resolver } from '@nestjs/graphql';
import { User } from '@socfony/prisma';
import { UserInterface } from './entities';
import { UserProfileEntity, UserProfileService } from './profile';

@Resolver((of) => UserInterface)
export class UserInterfaceResolver {
  constructor(private readonly userProfileService: UserProfileService) {}

  @ResolveField((returns) => UserProfileEntity)
  profile(@Parent() parent: User) {
    return this.userProfileService.resolveProfile(parent);
  }
}
