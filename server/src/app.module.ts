import { Module } from '@nestjs/common';
import { GraphQLModule } from './graphql';
import { LoggerModule } from './logger';
import { UsersModule } from './users/users.module';

/**
 * Application module.
 */
@Module({
  imports: [
    GraphQLModule,
    LoggerModule,
    UsersModule,
  ],
})
export class AppModule {}
