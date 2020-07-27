'use strict';

Object.defineProperty(exports, '__esModule', { value: true });

function _interopDefault (ex) { return (ex && (typeof ex === 'object') && 'default' in ex) ? ex['default'] : ex; }

var cloudbase = require('@bytegem/cloudbase');
var tcb = _interopDefault(require('node_modules/@cloudbase/node-sdk/lib/auth'));

var name = "moment";
var version = "1.0.0";

class GetCurrentUserCommand extends cloudbase.Command {
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
        const { _id: userId } = await (new GetCurrentUserCommand).handle(app);
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

function main(event, context) {
    const app = new cloudbase.Application({
        context,
        name,
        version,
    });
    app.addCommand('likeToggle', () => new LikeToggleCommand);
    return app.run(event);
}

exports.main = main;
