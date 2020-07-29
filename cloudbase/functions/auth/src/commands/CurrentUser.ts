import { Command, Application, CloudBaseError } from "@bytegem/cloudbase";
import tcb from "node_modules/@cloudbase/node-sdk/lib/auth";

interface User {
    _id: string;
    uid: string;
    createdAt: Date;
    updatedAt: Date;
    private?: string;
}

export class CurrentUserCommand extends Command {
    async handle(app: Application) {
        const auth = tcb.auth(app.cloudbase);
        const database = app.cloudbase.database();


        const { uid, customUserId, isAnonymous } = auth.getUserInfo();
        
        if ((!uid && !customUserId) || isAnonymous === true) {
            throw new CloudBaseError('Unauthorized', '请先登录');
        }

        let user: User | undefined = undefined;
        if (customUserId) {
            const result = await database.collection('users').doc(customUserId as string).get();
            user = result.data.pop();
        }

        if (!user && uid) {
            const result = await database.collection('users').where({uid}).get();
            user = result.data.pop();
        }

        if (!user) {
            user = { _id: "", uid, createdAt: new Date, updatedAt: new Date};
            const result = await database.collection('users').add(user);
            if (!result.id) {
                throw new CloudBaseError(-1, '获取用户数据失败');
            }
    
            user = {...user, _id: result.id};
        }
    
        if (!user.uid) {
            await database.collection('users').doc(user._id).update({uid});
            user = {...user, uid};
        }

        return user;
    }
}