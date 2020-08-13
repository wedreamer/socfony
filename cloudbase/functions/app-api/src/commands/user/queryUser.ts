import { App } from "../../app";
import queryCurrentUser from "./queryCurrentUser";

export default async function(app: App) {
    const currentUser = await queryCurrentUser(app);
    const { uid } = app.event.data;

    if (currentUser.uid == uid) {
        return currentUser;
    }

    const auth = app.server.auth();
    const { nickName, gender, country, province, city, avatarUrl } = await auth.getEndUserInfo(uid);

    return {
        nickName, gender, country, province, city, avatarUrl, uid,
    }
}