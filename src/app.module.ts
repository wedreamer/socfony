import { Module } from '@nestjs/common';
import { GraphQLModule } from './graphql';
import { LoggerModule } from './logger';
import { AuthorizationModule } from './authorization/authorization.module';
import { UsersModule } from './users/users.module';
import { SecurityCodeModule } from './security-code/security-code.module';

/**
 * Application module.
 */
@Module({
  imports: [
    AuthorizationModule,
    GraphQLModule,
    LoggerModule,
    UsersModule,
    SecurityCodeModule,
  ],
})
export class AppModule {}
