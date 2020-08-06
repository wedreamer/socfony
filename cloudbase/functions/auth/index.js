'use strict';

Object.defineProperty(exports, '__esModule', { value: true });

function _interopDefault (ex) { return (ex && (typeof ex === 'object') && 'default' in ex) ? ex['default'] : ex; }

var cloudbase = require('@bytegem/cloudbase');
var tcb = _interopDefault(require('@cloudbase/node-sdk/lib/auth'));

var name = "auth";
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

function main(event, context) {
    const app = new cloudbase.Application({
        context,
        name,
        version,
    });
    app.addCommand('currentUser', () => new CurrentUserCommand);
    return app.run(event);
}

exports.main = main;
