import { Module } from "@nestjs/common";
import { CloudBaseModule } from "./cloudbase/cloudbase.module";
import { UserModule } from "./users/user.module";

@Module({
    imports: [CloudBaseModule, UserModule],
})
export class AppModule {};
