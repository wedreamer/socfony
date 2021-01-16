import { Module } from '@nestjs/common';
import { AppGraphQLModule } from './graphql';
import { LoggerModule } from './logger';
import { AuthorizationModule } from './authorization/authorization.module';
import { SecurityCodeModule } from './security-code/security-code.module';
import { ConfigModule } from './config';
import { UserModule } from './user';

/**
 * Application module.
 */
@Module({
  imports: [
    AuthorizationModule,
    ConfigModule,
    AppGraphQLModule,
    LoggerModule,
    SecurityCodeModule,
    UserModule,
  ],
})
export class AppModule {}
