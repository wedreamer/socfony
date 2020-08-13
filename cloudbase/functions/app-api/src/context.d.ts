import { IContext } from "@cloudbase/node-sdk/lib/type";

export interface Context extends IContext {
    [name: string]: any;
}