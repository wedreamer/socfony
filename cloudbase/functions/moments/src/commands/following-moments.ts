import { Command, Application } from "@bytegem/cloudbase";
import { CurrentUserCommand } from "root-workspace-0b6124/cloudbase/functions/users/src/commands/CurrentUser";

export class FollowingMoments extends Command {
    async handle(app: Application, offset: number = 0) {
        const result = await (await this.createQuery(app)).limit(20).sort({ 'createdAt': -1 }).skip(offset).end();

        return (result.data as Array<any>).map((e) => e.id);
    }

    async createQuery(app: Application) {
        const { _id: userId } = await (new CurrentUserCommand).handle(app);

        const database = app.cloudbase.database();
        const command = database.command;

        return database.collection('moments')
            .aggregate()
            .lookup({
                from: "user-follow",
                as: "follow",
                let: {
                    userId: "$userId"
                },
                pipeline: command.aggregate.pipeline().match(command.expr(
                    command.aggregate.and([
                        command.aggregate.eq(['$userId', userId]),
                        command.aggregate.eq(["$targetUserId", "$$userId"]),
                    ]),
                )).project({
                    _id: false,
                    targetUserId: true,
                }).done(),
            })
            .lookup({
                from: "topic-user",
                as: "topices",
                let: {
                    topicId: "$topicId"
                },
                pipeline: command.aggregate.pipeline().match(command.expr(
                    command.aggregate.and([
                        command.aggregate.eq(['$userId', userId]),
                        command.aggregate.eq(["$topicId", "$$topicId"]),
                    ]),
                )).project({
                    _id: false,
                    topicId: true,
                }).done(),
            })
            .project({
                _id: false,
                id: "$_id",
                createdAt: true,
                userId: true,
                topicId: true,
                follow: command.aggregate.map({
                    input: "$follow",
                    in: '$$this.targetUserId',
                }),
                topices: command.aggregate.map({
                    input: '$topices',
                    in: '$$this.topicId',
                }),
            })
            .match(command.expr(
                command.aggregate.or([
                    command.aggregate.in(['$userId', '$follow']),
                    command.aggregate.in(['$topicId', '$topices']),
                    command.aggregate.eq(['$userId', userId]),
                ]),
            ))
            .project({ id: true, createdAt: true, });
    }
}