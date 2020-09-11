import { Global, Module } from "@nestjs/common";
import { CloudBaseService } from "./cloudbase.service";

@Global()
@Module({
    providers: [ CloudBaseService ],
    exports: [ CloudBaseService ],
})
export class CloudBaseModule {}
