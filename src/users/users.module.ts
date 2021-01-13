import { Module } from '@nestjs/common';
import { UserProfileModule } from './profile/profile.module';

/**
 * Users module.
 */
@Module({
  imports: [UserProfileModule],
})
export class UsersModule {}
