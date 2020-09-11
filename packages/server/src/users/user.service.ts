import { CloudBase } from "@cloudbase/node-sdk/lib/cloudbase";
import { Injectable } from "@nestjs/common";
import { CloudBaseService } from "../cloudbase/cloudbase.service";

@Injectable()
export class UserService {
    private readonly cloudbase: CloudBase;

    constructor(service: CloudBaseService) {
        this.cloudbase = service.server;
    }

    async current() {
        const auth = this.cloudbase.auth();
        const { userInfo: user } = await auth.getEndUserInfo();

        return user;
    }
}