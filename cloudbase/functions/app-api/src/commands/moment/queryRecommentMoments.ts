import { App } from "../../app";
import Schema, { Rules, ValidateError } from "async-validator";

const descriptor: Rules = {
    limit: {
        type: 'number'
    },
    offset: { type: 'number' },
};
const validator = new Schema(descriptor);

async function handler(app: App) {
    await validator.validate(app.event.data);

    const database = app.server.database();
    const { limit = 20, offset = 0 } = app.event.data;
    const command = database.command;
    const aggregate = command.aggregate;

    const weekAgo = Date.now() - 86400000 * 7;

    const result = await database.collection('moments')
        .aggregate()
        .lookup({
            from: "moment-liked-histories",
            as: "likes",
            let: {
                id: '$_id',
            },
            pipeline: aggregate.pipeline().match(command.expr(
                aggregate.and([
                    aggregate.gte(['$createdAt', weekAgo]),
                    aggregate.eq(['$$id', '$momentId']),
                ]),
            ))
            .project({ _id: true })
            .done(),

        })
        .lookup({
            from: "moments",
            as: 'commands',
            let: {
                id: '$_id',
            },
            pipeline: aggregate.pipeline().match(command.expr(
                aggregate.and([
                    aggregate.gte(['$createdAt', weekAgo]),
                    aggregate.eq(['$$id', '$momentId']),
                ]),
            ))
            .project({ _id: true })
            .done(),
        })
        .project({
            _id: true,
            createdAt: true,
            total: aggregate.sum([
                aggregate.size('$likes'),
                aggregate.size('$commands'),
            ]),
        })
        .sort({
            total: -1,
            createdAt: -1,
        })
        .limit(limit)
        .skip(offset)
        .end();

    return (result.data as Array<any>).map(e => e._id);
}

export default function(app: App) {
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
