import { App } from "../../app";

export default async function(app: App) {
    const auth = app.server.auth();
    const { userInfo: user } =  await auth.getEndUserInfo();

    if (!user.uid || user.isAnonymous == true) {
        throw new Error('请选登录');
    }

    return user;
}
