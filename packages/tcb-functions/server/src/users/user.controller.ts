import { Controller, Get, Param } from "@nestjs/common";
import { UserService } from "./user.service";

@Controller('users')
export class UserController {
    constructor(private readonly service: UserService) {}

    @Get(':id')
    user(@Param('id') id: string) {
        // request.user
        return { id };
    }
}