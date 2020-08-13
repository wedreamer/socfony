import { Command, Application } from "@bytegem/cloudbase";

export class RecommendMoments extends Command {
    async handle(app: Application, offset: number = 0) {
        const database = app.cloudbase.database();
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
            .skip(offset)
            .end();

        return (result.data as Array<any>).map(e => e._id);
    }
}