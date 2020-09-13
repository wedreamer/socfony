import { CloudBase } from "@cloudbase/node-sdk/lib/cloudbase";
import { Injectable } from "@nestjs/common";
import { CloudBaseService } from "../cloudbase/cloudbase.service";
import { UserDto } from "./dtos/user.dto";

@Injectable()
export class UserService {
    private readonly cloudbase: CloudBase;

    constructor(service: CloudBaseService) {
        this.cloudbase = service.server;
    }

    async current(): Promise<UserDto> {
        const auth = this.cloudbase.auth();
        const { userInfo: user } = await auth.getEndUserInfo();

        return user as UserDto;
    }

    async hasLogged(): Promise<boolean> {
        const { uid } = await this.current();
        return !!uid;
    }

    async find(uid: string): Promise<UserDto> {
        const auth = this.cloudbase.auth();
        const { userInfo: user } = await auth.getEndUserInfo(uid);

        return user;
    }
}