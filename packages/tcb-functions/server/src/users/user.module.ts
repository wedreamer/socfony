import { MiddlewareConsumer, Module, NestModule } from "@nestjs/common";
import { AuthMiddleware } from "src/middlewares/auth.middleware";
import { AuthController } from "./auth.controller";
import { UserController } from "./user.controller";
import { UserService } from "./user.service";

@Module({
    controllers: [AuthController,  UserController],
    providers: [UserService ],
    exports: [ UserService ],
})
export class UserModule implements NestModule {
    configure(consumer: MiddlewareConsumer) {
        consumer.apply(AuthMiddleware)
            .forRoutes(AuthController);
    }
}
