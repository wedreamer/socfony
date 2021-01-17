import { NestJS_Common } from '~deps';
import { UserProfileResolver } from './profile.resolver';
import { UserProfileService } from './profile.service';

@NestJS_Common.Module({
  providers: [UserProfileService, UserProfileResolver],
  exports: [UserProfileService],
})
export class UserProfuleModule {}
