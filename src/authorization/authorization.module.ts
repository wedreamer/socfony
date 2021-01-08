import { ClassProvider, Module } from '@nestjs/common';
import { APP_GUARD } from '@nestjs/core';
import { PrismaModule } from 'src/prisma';
import { AuthGuard } from './auth.guard';
import { AuthorizationResolver } from './authorization.resolver';
import { AuthorizationService } from './authorization.service';

const _AuthGuardProvider: ClassProvider<AuthGuard> = {
  provide: APP_GUARD,
  useClass: AuthGuard,
};

@Module({
  imports: [PrismaModule],
  providers: [
    _AuthGuardProvider,
    AuthorizationService,
    AuthorizationResolver,
  ],
  exports: [AuthorizationService],
})
export class AuthorizationModule {}
