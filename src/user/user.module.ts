import { Module } from '@nestjs/common';
import { UserProfuleModule } from './profile';
import { UserInterfaceResolver } from './user-interface.resolver';

/**
 * Users module.
 */
@Module({
  imports: [UserProfuleModule],
  providers: [UserInterfaceResolver],
})
export class UserModule {}
