import { Global, Module } from '@nestjs/common';
import { PrismaModule } from 'src/prisma';
import { SecurityCodeModule } from 'src/security-code/security-code.module';
import { AuthorizationResolver } from './authorization.resolver';
import { AuthorizationService } from './authorization.service';

@Global()
@Module({
  imports: [PrismaModule, SecurityCodeModule],
  providers: [AuthorizationService, AuthorizationResolver],
  exports: [AuthorizationService],
})
export class AuthorizationModule {}
