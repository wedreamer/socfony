import { NestJS } from '~deps';
import { CoreModule } from 'server-kernel/core';
import { PrismaModule } from 'server-kernel/prisma';
import { SecurityCodeModule } from 'server-kernel/security-code/security-code.module';
import { AuthGuard } from './auth.guard';
import { AuthService } from './auth.service';

@NestJS.Common.Module({
  imports: [CoreModule, PrismaModule, SecurityCodeModule],
  providers: [AuthGuard, AuthService],
  exports: [AuthService],
})
export class AuthModule {}
