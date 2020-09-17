import { MiddlewareConsumer, Module, NestModule, RequestMethod } from "@nestjs/common";
import { AuthMiddleware } from "src/middlewares/auth.middleware";
import { UserModule } from "src/users/user.module";
import { BusinessMomentController } from "./business-moment.controller";
import { LikerMomentController } from "./liker-moment.controller";
import { MomentController } from "./moment.controller";
import { MomentService } from "./moment.service";

@Module({
    controllers: [
        MomentController,
        BusinessMomentController,
        LikerMomentController,
    ],
    imports: [UserModule],
    providers: [MomentService],
})
export class MomentModule implements NestModule {
    configure(consumer: MiddlewareConsumer) {
        consumer.apply(AuthMiddleware).forRoutes(MomentController);
        consumer.apply(AuthMiddleware).forRoutes('moment-business/following');
        consumer.apply(AuthMiddleware).forRoutes(LikerMomentController);
    }
}
