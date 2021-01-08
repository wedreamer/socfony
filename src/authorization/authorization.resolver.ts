import { Args, Mutation, Query, Resolver } from "@nestjs/graphql";
import { PrismaClient } from "@prisma/client";
import { AuthorizationService } from "./authorization.service";
import { LoginInput, LoginType } from "./dto/login.input";
import { AuthorizationTokenEntity } from "./entities/authorization-token.entity";

@Resolver(of => AuthorizationTokenEntity)
export class AuthorizationResolver {
    constructor(
        private readonly authorizationService: AuthorizationService,
        private readonly prisma: PrismaClient,
    ) {}

    @Mutation(returns => AuthorizationTokenEntity)
    login(
        @Args({
            name: "data",
            type: () => LoginInput,
        })
        data: LoginInput
    ) {
        const { account, type, encrypted } = data;
        if (type === LoginType.PASSWORD) {
            return this.authorizationService.loginWithPassword(account, encrypted);
        }
    }

    @Query(returns => AuthorizationTokenEntity)
    authorization(
        @Args({
            name: "token",
            type: () => String,
        })
        token: string
    ) {
        return this.prisma.authorizationToken.findUnique({
            where: { token },
        });
    }
}