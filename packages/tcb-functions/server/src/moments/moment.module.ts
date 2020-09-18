import { MiddlewareConsumer, Module, NestModule, RequestMethod } from "@nestjs/common";
import { AuthMiddleware } from "src/middlewares/auth.middleware";
import { UserModule } from "src/users/user.module";
import { BusinessMomentController } from "./business-moment.controller";
import { LikerMomentController } from "./liker-moment.controller";
import { MomentVoteController } from "./moment-vote.controller";
import { MomentVoteService } from "./moment-vote.service";
import { MomentController } from "./moment.controller";
import { MomentService } from "./moment.service";

@Module({
    controllers: [
        MomentController,
        BusinessMomentController,
        LikerMomentController,
        MomentVoteController,
    ],
    imports: [UserModule],
    providers: [MomentService, MomentVoteService],
})
export class MomentModule implements NestModule {
    configure(consumer: MiddlewareConsumer) {
        consumer.apply(AuthMiddleware).forRoutes(
            'moment-business/following',
            MomentController,
            LikerMomentController,
            MomentVoteController,
        );
    }
}
