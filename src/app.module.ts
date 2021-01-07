import { Module } from '@nestjs/common';
import { GraphQLModule } from './graphql';
import { LoggerModule } from './logger';
import { AuthorizationModule } from './authorization/authorization.module';

/**
 * Application module.
 */
@Module({
  imports: [
    GraphQLModule,
    LoggerModule,
    AuthorizationModule,
  ],
})
export class AppModule {}
