import { Module } from '@nestjs/common';
import { ProfileModule } from './profile/profile.module';

/**
 * Users module.
 */
@Module({
  imports: [ProfileModule],
})
export class UsersModule {}
