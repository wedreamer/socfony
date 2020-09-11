import { Controller, Get } from "@nestjs/common";
import { UserService } from "./user.service";

@Controller('auth')
export class AuthController {
    constructor(private readonly service: UserService) {}

    @Get('user')
    async user() {
        return await this.service.current();
    }
}