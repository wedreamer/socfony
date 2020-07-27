import { Command, Application } from "@bytegem/cloudbase";
import { GetCurrentUserCommand } from "cloudbase/functions/auth/src/commands/get-current-user";

export class LikeToggleCommand extends Command {
    async handle(app: Application, momentId: string) {
        const { _id: userId } = await (new GetCurrentUserCommand).handle(app);
        const database = app.cloudbase.database();
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
}