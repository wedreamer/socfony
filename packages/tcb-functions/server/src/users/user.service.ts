import { CloudBase } from "@cloudbase/node-sdk/lib/cloudbase";
import { Injectable } from "@nestjs/common";
import { CloudBaseService } from "../cloudbase/cloudbase.service";
import { UserDto } from "./dtos/user.dto";

type HasLoggedType = string | boolean;

@Injectable()
export class UserService {
    private readonly cloudbase: CloudBase;

    constructor(service: CloudBaseService) {
        this.cloudbase = service.server;
    }

    async current(): Promise<UserDto> {
        const uid = await this.hasLogged<string>(true);

        if (!!uid) {
            return await this.find(uid);
        }
    }

    async hasLogged<T extends HasLoggedType>(useUID: boolean = false): Promise<T> {
        const auth = this.cloudbase.auth();
        const { userInfo } = await auth.getEndUserInfo();
        const { uid } = userInfo;
        if (useUID) {
            return uid as T;
        }
        
        return (!!uid) as unknown as T;
    }

    async find(uid: string): Promise<UserDto> {
        const auth = this.cloudbase.auth();
        const { userInfo } = await auth.getEndUserInfo(uid);
        return new UserDto(userInfo);
    }
}