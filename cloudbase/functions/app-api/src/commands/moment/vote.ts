import Schema, { Rules } from 'async-validator';

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
        async asyncValidator(_rule, value: string, fn) {
            try {
                await hasMomentExists(_app, value);
            } catch (error) {
                fn(error);
            }
        }
    },
    vote: {
        required: true,
        type: 'string',
        async asyncValidator(_rule, value: string, fn, source) {
            const { momentId } = source;
            try {
                await hasVoteExists(_app, momentId, value);
            } catch (error) {
                fn(error);
            }
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

export default async function(app: App) {
    _app = app;

    await validator.validate(app.event.data);

    const { uid: userId } = queryCurrentUser(app);
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