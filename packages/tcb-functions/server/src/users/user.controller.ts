import { Controller, Get, Param } from "@nestjs/common";
import { UserService } from "./user.service";

@Controller('users')
export class UserController {
    constructor(private readonly service: UserService) {}

    @Get(':uid')
    async user(@Param('uid') uid: string) {
        return await this.service.find(uid);
    }
}