import { App } from "./app";
import { EventPayload } from "./event";
import { Context } from "./context";

import queryUser from "./commands/user/queryUser";
import queryCurrentUser from "./commands/user/queryCurrentUser";
import queryFollowingMoments from "./commands/moment/queryFollowingMoments";
import queryRecommentMoments from "./commands/moment/queryRecommentMoments";
import createMomentCommand from "./commands/moment/createMomentCommand";
import toggleLikeMoment from "./commands/moment/toggleLikeMoment";
import tapMomentVoteItemCommand from "./commands/moment/tapMomentVoteItemCommand";
import { createTopicCommand } from "./commands/topic/createTopicCommand";

export function main(event: EventPayload, context: Context) {
    // create app
    const app = new App(context);

    // User
    app.command('user:current', queryCurrentUser);
    app.command('user:query', queryUser);

    // Moment
    app.command('moment:followingToMoments', queryFollowingMoments);
    app.command('moment:recommentMoments', queryRecommentMoments);
    app.command('moment:toggleLike', toggleLikeMoment);
    app.command('moment:tapVoteItem', tapMomentVoteItemCommand);
    app.command('moment:create', createMomentCommand);

    // Topic
    app.command('topic:create', createTopicCommand);

    return app.handle(event);
}
