import { NestJS } from '~deps';
import { UserProfileResolver } from './profile.resolver';
import { UserProfileService } from './profile.service';

@NestJS.Common.Module({
  providers: [UserProfileService, UserProfileResolver],
  exports: [UserProfileService],
})
export class UserProfuleModule {}
