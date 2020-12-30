import { DynamicModule } from '@nestjs/common';
import { GraphQLModule as _graphql } from '@nestjs/graphql';

export const GraphQLModule: DynamicModule = _graphql.forRootAsync({
    useFactory() {
        return {
            autoSchemaFile: true,
            installSubscriptionHandlers: true,
            debug: true,
            playground: true,
            path: "/",
        };
    }
});
