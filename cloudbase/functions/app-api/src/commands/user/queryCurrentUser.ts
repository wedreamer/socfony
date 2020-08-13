import { App } from "../../app";

export default (app: App) => {
    const auth = app.server.auth();
    
    return auth.getEndUserInfo();
}
