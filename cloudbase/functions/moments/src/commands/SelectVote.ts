import { Command, Application, CloudBaseError } from "@bytegem/cloudbase";
import { CurrentUserCommand } from "root-workspace-0b6124/cloudbase/functions/users/src/commands/CurrentUser";

interface VoteItem {
    name: string;
    count?: number;
}

export class SelectVoteCommand extends Command {
    async handle(app: Application, data?: any) {
        const { _id: userId } = await (new CurrentUserCommand).handle(app);
        const { momentId, vote: voteText } = data;
        const db = app.cloudbase.database();
        const _ = db.command;

        let result = await db.collection('moment-vote-user-selected').where({
            momentId,
            userId,
        }).count();

        if (result.total) {
            return;
        }

        result = await db.collection('moments').doc(momentId).field('vote').get();
        if (result.data.length <= 0) {
            throw new CloudBaseError('Not Found', `Moment doc(${momentId}) not found`);
        }

        const { vote } = result.data.pop();
        const index = (vote as Array<VoteItem>).map(value => value.name).indexOf(voteText);
        if (index < 0) {
            throw new CloudBaseError('illegal', `Moment doc(${momentId}) don't includes vote item(${voteText})`);
        }

        await db.runTransaction(async (transaction: any) => {
            await transaction.collection('moments').doc(momentId).update({
                vote: (vote as Array<VoteItem>).map(value => {
                    if (voteText == value.name) {
                        value.count = (value.count ? value.count : 0) + 1;
                    }
                    return value;
                }),
            });
            await transaction.collection('moment-vote-user-selected').add({
                momentId, userId, vote: voteText,
                createdAt: new Date,
            });
        });
    }
}