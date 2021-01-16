import { DynamicModule, Global, Module } from '@nestjs/common';
import { GraphQLModule } from '@nestjs/graphql';
import { AuthorizationModule } from 'src/authorization';
import { GqlOptionsFactory } from './graphql-options.factory';

// create GraphQL dynamic module.
const _GraphQLDynamicModule: DynamicModule = GraphQLModule.forRootAsync({
  imports: [AuthorizationModule],
  useClass: GqlOptionsFactory,
});

/**
 * GraphQL module.
 */
@Module({
  imports: [_GraphQLDynamicModule],
})
export class AppGraphQLModule {}
