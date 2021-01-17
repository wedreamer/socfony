import { Module } from '@nestjs/common';
import { UserProfileResolver } from './profile.resolver';
import { UserProfileService } from './profile.service';

@Module({
  providers: [UserProfileService, UserProfileResolver],
  exports: [UserProfileService],
})
export class UserProfuleModule {}
