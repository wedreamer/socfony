import CloudBaseManager from "@cloudbase/manager-node";
import { init as cloudBaseServerInit } from "@cloudbase/node-sdk";
import { CloudBase as ServerCloudBase } from "@cloudbase/node-sdk/lib/cloudbase";

import { __CLOUDBASE_ENV_ID__ } from "src/__cloudbaserc__";

export function setMockTcbFunctionAuthEnv(userId: string): void {
    if (!userId) {
        return;
    }
    const keys = (process.env.TCB_CONTEXT_KEYS || '')
        .split(',')
        .filter(value => value != 'TCB_UUID');
    keys.push('TCB_UUID');
    process.env.TCB_CONTEXT_KEYS = keys.filter(v => !!v).join(',');
    process.env.TCB_UUID = userId;
}

export function removeMockedFunctionAuthEnv() {
    const keys = (process.env.TCB_CONTEXT_KEYS || '').split(',');
    process.env.TCB_CONTEXT_KEYS = keys.filter(value => value != 'TCB_UUID').filter(v => !!v).join(',');
    process.env.TCB_UUID = undefined;
}

let __tcb_server_envs: Record<string, ServerCloudBase> = {};
export function createCloudBaseServer(): ServerCloudBase {
    const instance: ServerCloudBase = __tcb_server_envs[__CLOUDBASE_ENV_ID__];
    if (instance instanceof ServerCloudBase) {
        return instance;
    }

    __tcb_server_envs[__CLOUDBASE_ENV_ID__] = cloudBaseServerInit({
        env: __CLOUDBASE_ENV_ID__,
    });

    return __tcb_server_envs[__CLOUDBASE_ENV_ID__];
}

export function createCloudBaseManager(): CloudBaseManager {
    return CloudBaseManager.init({
        envId: __CLOUDBASE_ENV_ID__,
    });
}

export function tcbStorageCloudFileIdToPath(fileId: string) {
    return fileId.replace(/cloud:\/\/[a-zA-z0-9\.\-\_]+\//, '');
}
