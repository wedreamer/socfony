import { init as cloudBaseServerInit, SYMBOL_CURRENT_ENV } from "@cloudbase/node-sdk";
import { CloudBase } from "@cloudbase/node-sdk/lib/cloudbase";
import { Injectable } from "@nestjs/common";

@Injectable()
export class CloudBaseService {
    /**
     * CloudBase server SDK instance.
     * @var CloudBase
     */
    public readonly server: CloudBase;

    constructor() {
        this.server = this._createCloudBaseServerInstance();
    }

    private _createCloudBaseServerInstance(): CloudBase {
        return cloudBaseServerInit({
            env: SYMBOL_CURRENT_ENV as unknown as string,
        });
    }
}
