import { App } from "./app";
import queryUser from "./commands/user/queryUser";
import queryCurrentUser from "./commands/user/queryCurrentUser";
import queryFollowingMoments from "./commands/moment/queryFollowingMoments";

// create app
const app = new App();

// User
app.command('queryCurrentUser', queryCurrentUser);
app.command('queryUser', queryUser);

// Moment
app.command('queryFollowingMoments', queryFollowingMoments);

export const main = app.handle;
