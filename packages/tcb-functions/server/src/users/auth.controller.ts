import { Controller, Get, HttpCode } from "@nestjs/common";
import { UserDto } from "./dtos/user.dto";
import { UserService } from "./user.service";

@Controller('auth')
export class AuthController {
    constructor(private readonly service: UserService) {}

    @Get('user')
    @HttpCode(200)
    async user(): Promise<UserDto> {
        return await this.service.current();
    }
}