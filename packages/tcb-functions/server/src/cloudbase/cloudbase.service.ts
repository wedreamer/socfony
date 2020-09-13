import { init as cloudBaseServerInit, SYMBOL_CURRENT_ENV } from "@cloudbase/node-sdk";
import { CloudBase } from "@cloudbase/node-sdk/lib/cloudbase";
import { Injectable } from "@nestjs/common";
import { __CLOUDBASE_ENV_ID__ } from "src/__cloudbaserc__";

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
            env: __CLOUDBASE_ENV_ID__,
        });
    }
}
