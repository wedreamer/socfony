import { Context } from "./context";
import tcb from "@cloudbase/node-sdk";
import { CloudBase } from "@cloudbase/node-sdk/lib/cloudbase";

export function cloudbaseServer(context: Context): CloudBase {
    const { namespace } = context;

    return tcb.init({
        env: namespace,
    });
}
