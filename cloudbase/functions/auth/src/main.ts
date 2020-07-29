import { CloudBasePayload, CloudBaseContext, Application } from "@bytegem/cloudbase";
import { name, version } from "../package.json";
import { CurrentUserCommand } from "./commands/CurrentUser";

export function main(event: CloudBasePayload, context: CloudBaseContext) {
    const app = new Application({
        context,
        name,
        version,
    });
    app.addCommand('currentUser', () => new CurrentUserCommand);

    return app.run(event);
}

