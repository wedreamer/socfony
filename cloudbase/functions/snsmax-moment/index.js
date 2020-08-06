'use strict';

Object.defineProperty(exports, '__esModule', { value: true });

function _interopDefault (ex) { return (ex && (typeof ex === 'object') && 'default' in ex) ? ex['default'] : ex; }

var cloudbase = require('@bytegem/cloudbase');
var tcb = _interopDefault(require('@cloudbase/node-sdk/lib/auth'));

var name = "moment";
var version = "1.0.0";

class CurrentUserCommand extends cloudbase.Command {
    async handle(app) {
        const auth = tcb.auth(app.cloudbase);
        const database = app.cloudbase.database();
        const { uid, customUserId, isAnonymous } = auth.getUserInfo();
        if ((!uid && !customUserId) || isAnonymous === true) {
            throw new cloudbase.CloudBaseError('Unauthorized', '请先登录');
        }
        let user = undefined;
        if (customUserId) {
            const result = await database.collection('users').doc(customUserId).get();
            user = result.data.pop();
        }
        if (!user && uid) {
            const result = await database.collection('users').where({ uid }).get();
            user = result.data.pop();
        }
        if (!user) {
            user = { _id: "", uid, createdAt: new Date, updatedAt: new Date };
            const result = await database.collection('users').add(user);
            if (!result.id) {
                throw new cloudbase.CloudBaseError(-1, '获取用户数据失败');
            }
            user = { ...user, _id: result.id };
        }
        if (!user.uid) {
            await database.collection('users').doc(user._id).update({ uid });
            user = { ...user, uid };
        }
        return user;
    }
}

class LikeToggleCommand extends cloudbase.Command {
    async handle(app, momentId) {
        const { _id: userId } = await (new CurrentUserCommand).handle(app);
        const database = app.cloudbase.database();
        const command = database.command;
        const collection = database.collection('moment-liked-histories');
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

class FollowingMoments extends cloudbase.Command {
    async handle(app, offset = 0) {
        const result = await (await this.createQuery(app)).limit(20).sort({ 'createdAt': -1 }).skip(offset).end();
        return result.data.map((e) => e.id);
    }
    async createQuery(app) {
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
            pipeline: command.aggregate.pipeline().match(command.expr(command.aggregate.and([
                command.aggregate.eq(['$userId', userId]),
                command.aggregate.eq(["$targetUserId", "$$userId"]),
            ]))).project({
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
            pipeline: command.aggregate.pipeline().match(command.expr(command.aggregate.and([
                command.aggregate.eq(['$userId', userId]),
                command.aggregate.eq(["$topicId", "$$topicId"]),
            ]))).project({
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
            .match(command.expr(command.aggregate.or([
            command.aggregate.in(['$userId', '$follow']),
            command.aggregate.in(['$topicId', '$topices']),
            command.aggregate.eq(['$userId', userId]),
        ])))
            .project({ id: true, createdAt: true, });
    }
}

class SelectVoteCommand extends cloudbase.Command {
    async handle(app, data) {
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
            throw new cloudbase.CloudBaseError('Not Found', `Moment doc(${momentId}) not found`);
        }
        const { vote } = result.data.pop();
        const index = vote.map(value => value.name).indexOf(voteText);
        if (index < 0) {
            throw new cloudbase.CloudBaseError('illegal', `Moment doc(${momentId}) don't includes vote item(${voteText})`);
        }
        await db.runTransaction(async (transaction) => {
            await transaction.collection('moments').doc(momentId).update({
                vote: vote.map(value => {
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

class RecommendMoments extends cloudbase.Command {
    async handle(app, offset = 0) {
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
            pipeline: aggregate.pipeline().match(command.expr(aggregate.and([
                aggregate.gte(['$createdAt', weekAgo]),
                aggregate.eq(['$$id', '$momentId']),
            ])))
                .project({ _id: true })
                .done(),
        })
            .lookup({
            from: "moments",
            as: 'commands',
            let: {
                id: '$_id',
            },
            pipeline: aggregate.pipeline().match(command.expr(aggregate.and([
                aggregate.gte(['$createdAt', weekAgo]),
                aggregate.eq(['$$id', '$momentId']),
            ])))
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
        return result.data.map(e => e._id);
    }
}

function main(event, context) {
    const app = new cloudbase.Application({
        context,
        name,
        version,
    });
    app.addCommand('likeToggle', () => new LikeToggleCommand);
    app.addCommand('followingMoments', () => new FollowingMoments);
    app.addCommand('selectVote', () => new SelectVoteCommand);
    app.addCommand('recommendMoments', () => new RecommendMoments);
    return app.run(event);
}

exports.main = main;
