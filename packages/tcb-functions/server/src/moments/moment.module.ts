import { MiddlewareConsumer, Module, NestModule } from "@nestjs/common";
import { AuthMiddleware } from "src/middlewares/auth.middleware";
import { UserModule } from "src/users/user.module";
import { MomentController } from "./moment.controller";
import { MomentService } from "./moment.service";

@Module({
    controllers: [MomentController],
    imports: [UserModule],
    providers: [MomentService,]
})
export class MomentModule implements NestModule {
    configure(consumer: MiddlewareConsumer) {
        consumer.apply(AuthMiddleware).forRoutes(MomentController);
    }
}
