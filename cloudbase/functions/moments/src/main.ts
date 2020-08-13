import { Application, CloudBasePayload, CloudBaseContext } from "@bytegem/cloudbase";
import { name, version } from "../package.json";
import { LikeToggleCommand } from "./commands/like-toggle";
import { FollowingMoments } from "./commands/following-moments";
import { SelectVoteCommand } from "./commands/SelectVote";
import { RecommendMoments } from "./commands/RecommendMoments";

export function main(event: CloudBasePayload, context: CloudBaseContext) {
    const app = new Application({
        context,
        name,
        version,
    });
    app.addCommand('likeToggle', () => new LikeToggleCommand)
    app.addCommand('followingMoments', () => new FollowingMoments);
    app.addCommand('selectVote', () => new SelectVoteCommand);
    app.addCommand('recommendMoments', () => new RecommendMoments);

    return app.run(event);
}
