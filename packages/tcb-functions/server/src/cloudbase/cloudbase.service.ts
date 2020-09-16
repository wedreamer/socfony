import CloudBaseManager from "@cloudbase/manager-node";
import { CloudBase as ServerCloudBase } from "@cloudbase/node-sdk/lib/cloudbase";
import { Injectable } from "@nestjs/common";
import { createCloudBaseManager, createCloudBaseServer } from "src/utils/cloudbase.util";

@Injectable()
export class CloudBaseService {
    get server(): ServerCloudBase {
        return createCloudBaseServer();
    }

    get manager(): CloudBaseManager {
        return createCloudBaseManager();
    }
}
