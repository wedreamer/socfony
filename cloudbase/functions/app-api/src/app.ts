import { EventPayload } from "./event";
import { Context } from "./context";
import { CloudBase } from "@cloudbase/node-sdk/lib/cloudbase";
import { cloudbaseServer } from "./cloudbase-server";

export class App {
    event!: EventPayload;
    context!: Context;
    commands: Map<string, Function> = new Map;

    public get server() : CloudBase {
        return cloudbaseServer();
    }
    
    public get currentCommand() : string {
        return this.event.command;
    }
    
    async handle(context: Context, event: EventPayload) {
        this.context = context;
        this.event = event;
        this.context = context;

        const command = this.commands.get(this.currentCommand) as Function;

        return await command(this);
    }

    command(name: string, command: Function) {
        this.commands.set(name, command);
    }
}
