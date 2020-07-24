import { Application, CloudBasePayload, CloudBaseContext } from "@bytegem/cloudbase";
import { name, version } from "../package.json";
import { PostCommand } from "./commands/post";

export function main(event: CloudBasePayload, context: CloudBaseContext) {
    const app = new Application({
        context,
        name,
        version,
    });
    app.addCommand('post', () => new PostCommand);

    return app.run(event);
}