import { Module } from "@nestjs/common";
import { AuthController } from "./auth.controller";
import { UserController } from "./user.controller";
import { UserService } from "./user.service";

@Module({
    controllers: [AuthController,  UserController],
    providers: [UserService ],
    exports: [ UserService ],
})
export class UserModule {}
