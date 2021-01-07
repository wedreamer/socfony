import { Injectable } from "@nestjs/common";
import { GqlModuleOptions } from "@nestjs/graphql";
import { Request } from "express";

@Injectable()
export class GraphQLOptionService {
    public async getOptions(): Promise<GqlModuleOptions>  {
        return {
            autoSchemaFile: true,
            installSubscriptionHandlers: false,
            debug: true,
            playground: true,
            path: "/",
            context: this.context,
        }
    }

    private context(context: any) {
        const { req: request, res: _res, ...payload } = context;

        return Object.assign(payload, this.resolveHttpContext(request));
    }

    private resolveHttpContext(request: Request) {
        const Authorization = request.header('Authorization');

        return { Authorization };
    }
}