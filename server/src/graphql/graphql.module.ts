import { DynamicModule, Module } from '@nestjs/common';
import { GraphQLModule as _graphql, Query, Resolver } from '@nestjs/graphql';
import { GraphQLOptionService } from './graphql-option.service';

function GraphQLContextResolve(context: Record<string, any>) {
    const { req, ...payload } = context;
    return context;
    // console.log(context);
}

@Module({
    providers: [GraphQLOptionService],
    exports: [GraphQLOptionService],
})
class GraphQLModuleOption{}

export const module: DynamicModule = _graphql.forRootAsync({
    imports: [GraphQLModuleOption],
    inject: [GraphQLOptionService],
    useFactory: (service: GraphQLOptionService) => service.getOptions(),
});

@Resolver()
class demo {
    @Query(returns => Boolean)
    demo() {
        return true;
    }
}

@Module({
    imports: [module, GraphQLModuleOption],
    providers: [demo],
    exports: [module, GraphQLModuleOption],
})
export class GraphQLModule{}
