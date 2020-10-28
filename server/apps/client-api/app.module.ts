import { Module } from "@nestjs/common";
import { CommonModule } from "src";
import { AppController } from "./app.controller";

@Module({
    imports: [
        CommonModule,
    ],
    controllers: [AppController],
})
export class AppModule {}