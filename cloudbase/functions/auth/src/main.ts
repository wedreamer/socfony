import { CloudBasePayload, CloudBaseContext, Application } from "@bytegem/cloudbase";
import pkg from "../package.json";
import { GetCurrentUserCommand } from "./commands/get-current-user";
import { ENODEV } from "constants";

export function main(event: CloudBasePayload, context: CloudBaseContext) {
    const app = new Application({
        context,
        name: pkg.name,
        version: pkg.version,
    });
    app.addCommand('getCurrentUser', () => new GetCurrentUserCommand);

    return app.run(event);
}

