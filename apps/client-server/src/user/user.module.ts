import { Module } from '@nestjs/common';
import { UserProfileModule } from './profile';

@Module({
  imports: [UserProfileModule],
})
export class UserModule {}
