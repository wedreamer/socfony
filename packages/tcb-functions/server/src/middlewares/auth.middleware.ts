import { Injectable, NestMiddleware, UnauthorizedException } from "@nestjs/common";
import { Request, Response } from "express";
import { UserService } from "src/users/user.service";

@Injectable()
export class AuthMiddleware implements NestMiddleware<Request, Response> {
    constructor(private readonly service: UserService) {}

    async use(request: Request, _response: Response, next: () => void): Promise<void> {
        const hasLogged = await this.service.hasLogged();
        if (!hasLogged) {
            throw new UnauthorizedException()
        }

        request.user = await this.service.current();
        next();
    }
}
