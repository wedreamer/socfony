import { Module } from "@nestjs/common";
import { LoggerModule } from "./logger";
import { PrismaModule } from "./prisma";

/**
 * Application module.
 */
@Module({
    imports: [LoggerModule, PrismaModule],
})
export class AppModule {}
