import { Application, CloudBasePayload, CloudBaseContext } from "@bytegem/cloudbase";
import { name, version } from "../package.json";
import { LikeToggleCommand } from "./commands/like-toggle";

export function main(event: CloudBasePayload, context: CloudBaseContext) {
    const app = new Application({
        context,
        name,
        version,
    });
    app.addCommand('likeToggle', () => new LikeToggleCommand);

    return app.run(event);
}
