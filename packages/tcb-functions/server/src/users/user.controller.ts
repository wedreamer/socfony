import { Controller, Get, HttpCode, HttpStatus, Param } from "@nestjs/common";
import { UserDto } from "./dtos/user.dto";
import { ParseUserPipe } from "./pipes/parse-user.pipe";

@Controller('users')
export class UserController {
    @Get(':uid')
    @HttpCode(HttpStatus.OK)
    user(@Param('uid', ParseUserPipe) user: UserDto): UserDto {
        return user;
    }
}