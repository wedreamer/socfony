import { App } from "./app";
import queryUser from "./commands/user/queryUser";
import queryCurrentUser from "./commands/user/queryCurrentUser";
import queryFollowingMoments from "./commands/moment/queryFollowingMoments";
import queryRecommentMoments from "./commands/moment/queryRecommentMoments";
import momentToggleLike from "./commands/moment/likeToggle";
import vote from "./commands/moment/vote";

// create app
const app = new App();

// User
app.command('user:current', queryCurrentUser);
app.command('user:query', queryUser);

// Moment
app.command('moment:followingToMoments', queryFollowingMoments);
app.command('moment:recommentMoments', queryRecommentMoments);
app.command('moment:toggleLike', momentToggleLike);
app.command('moment:vote', vote);

export const main = app.handle;
