import { DynamicModule, Module } from '@nestjs/common';
import { GraphQLModule as _graphql } from '@nestjs/graphql';
import { AuthorizationModule } from 'src/authorization';
import { GqlOptionsFactory } from './graphql-options.factory';

const _GraphQLDynamicModule: DynamicModule = _graphql.forRootAsync({
  imports: [AuthorizationModule],
  useClass: GqlOptionsFactory,
});

@Module({
  imports: [_GraphQLDynamicModule],
})
export class GraphQLModule {}
