import { Controller, Get, Header, HttpCode, Req } from "@nestjs/common";
import { Request } from "express";
// import { Request } from "express";
import { UserService } from "./user.service";

@Controller('auth')
export class AuthController {
    constructor(private readonly service: UserService) {}

    @Get('user')
    @HttpCode(201)
    @Header('X-Powered-By', '222')
    async user(@Req() request: Request) {
        return await this.service.current();
    }
}