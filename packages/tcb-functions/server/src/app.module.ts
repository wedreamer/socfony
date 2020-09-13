import { MiddlewareConsumer, Module, NestModule } from "@nestjs/common";
import { APP_FILTER } from "@nestjs/core";
import { CloudBaseModule } from "./cloudbase/cloudbase.module";
import { HttpExceptionFilter } from "./http.exception.filter";
import { HttpMiddleware } from "./middlewares/http.middleware";
import { UserModule } from "./users/user.module";

@Module({
    imports: [CloudBaseModule, UserModule],
    providers: [
        {
            provide: APP_FILTER,
            useClass: HttpExceptionFilter,
        }
    ],
})
export class AppModule implements NestModule {
    configure(consumer: MiddlewareConsumer) {
        consumer.apply(HttpMiddleware)
            .forRoutes('*');
    }
};
