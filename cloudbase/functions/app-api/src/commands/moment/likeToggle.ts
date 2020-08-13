import { App } from "../../app";
import queryCurrentUser from "../user/queryCurrentUser";

export default async function(app: App) {
    const { uid: userId } = await queryCurrentUser(app);
    const { momentId } = app.event.data;
    const database = app.server.database();
    const command = database.command;
    const collection = database.collection('moment-liked-histories')
    const action = collection.where({ userId, momentId });
    const moment = database.collection('moments').doc(momentId);

    const result = await action.count();
        
    if (result.total) {
        moment.update({
            count: {
                like: command.inc(-1),
            },
        });
        return action.remove();
    }

    collection.add({ userId, momentId, createdAt: new Date, updatedAt: new Date });
    moment.update({
        count: {
            like: command.inc(1),
        },
    });
}