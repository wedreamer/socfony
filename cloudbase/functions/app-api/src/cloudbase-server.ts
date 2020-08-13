import { Context } from "./context";
import { init } from "@cloudbase/node-sdk";
import { CloudBase } from "@cloudbase/node-sdk/lib/cloudbase";

export function cloudbaseServer(): CloudBase {
    return init();
}
