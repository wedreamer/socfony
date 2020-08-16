import { EventPayload } from "./event";
import { Context } from "./context";
import { CloudBase } from "@cloudbase/node-sdk/lib/cloudbase";
import CloudBaseManager from '@cloudbase/manager-node';
import { cloudbaseServer } from "./cloudbase-server";

export class App {
    event!: EventPayload;
    context!: Context;
    commands: Map<string, Function>;

    constructor(context: Context) {
        this.commands = new Map<string, Function>();
        this.context = context;
    }

    public get server() : CloudBase {
        return cloudbaseServer(this.context);
    }

    public get manager(): CloudBaseManager {
        return CloudBaseManager.init({
            envId: this.context.namespace,
        });
    }
    
    public get currentCommand() : string {
        return this.event.command;
    }
    
    async handle(event: EventPayload) {
        this.event = event;

        console.log(this.commands.size);

        const command = this.commands.get(this.currentCommand);
        if (command instanceof Function) {
            return await command(this);
        }

        throw `Unsupported command(${this.currentCommand})`;
    }

    command(name: string, command: Function) {
        this.commands.set(name, command);
    }
}
