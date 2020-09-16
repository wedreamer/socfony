import { MiddlewareConsumer, Module, NestModule } from "@nestjs/common";
import { APP_FILTER } from "@nestjs/core";
import { CloudBaseModule } from "./cloudbase/cloudbase.module";
import { HttpExceptionFilter } from "./http.exception.filter";
import { HttpMiddleware } from "./middlewares/http.middleware";
import { TcbAuthMiddleware } from "./middlewares/tcb.auth.middleware";
import { MomentModule } from "./moments/moment.module";
import { UserModule } from "./users/user.module";

@Module({
    imports: [CloudBaseModule, UserModule, MomentModule],
    providers: [
        {
            provide: APP_FILTER,
            useClass: HttpExceptionFilter,
        }
    ],
})
export class AppModule implements NestModule {
    configure(consumer: MiddlewareConsumer) {
        consumer.apply(
                HttpMiddleware, 
                // TcbAuthMiddleware, 不使用云接入情况下不启用
            )
            .forRoutes('*');
    }
};
