import { Controller, Get, Param } from "@nestjs/common";
import { UserService } from "./user.service";

@Controller('users')
export class UserController {
    constructor(private readonly service: UserService) {}

    @Get(':uid')
    async user(@Param('uid') uid: string) {
        try {
            const user = await this.service.find(uid);
            return user;
        } catch (e) {
            console.log(e);
        }
    }
}