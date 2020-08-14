import Schema, { Rules, ValidateError } from 'async-validator';

import { App } from "../../app";
import queryCurrentUser from "../user/queryCurrentUser";

interface VoteItem {
    name: string;
    count?: number;
}

let _app: App;

const descriptor: Rules = {
    momentId: {
        required: true,
        type: 'string',
        async asyncValidator(_rule, value: string) {
            await hasMomentExists(_app, value);
        }
    },
    vote: {
        required: true,
        type: 'string',
        async asyncValidator(_rule, value: string, _fn, source) {
            const { momentId } = source;
            await hasVoteExists(_app, momentId, value);
        }
    }
};

async function hasMomentExists(app: App, momentId: string) {
    const database = app.server.database();
    const result = await database.collection('moments').doc(momentId).get();
    if (result.data.length <= 0) {
        throw new Error(`Moment doc(${momentId}) not found`);
    }
}

async function hasVoteExists(app: App, momentId: string, vote: string) {
    const database = app.server.database();
    const result = await database.collection('moments').doc(momentId).field('vote').get();
    const { vote: votes } = result.data.pop();
    const index = (votes as Array<VoteItem>).map(value => value.name).indexOf(vote);
    if (index < 0) {
        throw new Error(`Moment doc(${momentId}) don't includes vote item(${vote})`);
    }
}

const validator = new Schema(descriptor);

async function handler(app: App) {
    const { uid: userId } = await queryCurrentUser(app);
    const { momentId, vote: voteText } = app.event.data;

    const db = app.server.database();
    const _ = db.command;

    let result = await db.collection('moment-vote-user-selected').where({
        momentId,
        userId,
    }).count();

    if (result.total) {
        return;
    }

    result = await db.collection('moments').doc(momentId).field('vote').get();
    const { vote } = result.data.pop();
    const index = (vote as Array<VoteItem>).map(value => value.name).indexOf(voteText);

    await db.runTransaction(async (transaction: any) => {
        await transaction.collection('moments').doc(momentId).update({
            [`vote.${index}.count`]: _.inc(+1),
        });
        await transaction.collection('moment-vote-user-selected').add({
            momentId, userId, vote: voteText,
            createdAt: new Date,
        });
    });
}

export default function(app: App) {
    _app = app;

    return new Promise<any>((resolve, reject) => {
        validator.validate(app.event.data, { first: true }, errors => {
            if (errors) {
                const error = errors.pop() as ValidateError;
                return reject(new Error(error.message));
            }

            return handler(app).then(resolve).catch(reject);
        });
    });
}