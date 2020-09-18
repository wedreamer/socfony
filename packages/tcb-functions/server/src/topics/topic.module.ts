import { MiddlewareConsumer, Module, NestModule } from "@nestjs/common";
import { AuthMiddleware } from "src/middlewares/auth.middleware";
import { TopicController } from "./topic.controller";
import { TopicService } from "./topic.service";

@Module({
    controllers: [TopicController],
    providers: [TopicService],
})
export class TopicModule implements NestModule {
    configure(consumer: MiddlewareConsumer) {
        consumer.apply(AuthMiddleware).forRoutes(TopicController);
    }
}
