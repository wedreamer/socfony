import { App } from "../../app";
import queryCurrentUser from "../user/queryCurrentUser";
import Schema, { Rules, ValidateError } from "async-validator";
import { getCloudFilePath } from "../../utils/managerFilePathUtil";

let _app: App;

const descriptor: Rules = {
    cover: {
        required: true,
        type: "string",
        async asyncValidator(_rule, value: string) {
            if (!value) {
                throw new Error('必须设置话题封面');
            }
            const manager = _app.manager;
            const file = await manager.storage.getFileInfo(getCloudFilePath(value));
            const hasMatch =  file.Type.match('image/*') != null;
            if (!hasMatch) {
                throw new Error('话题封面不合法');
            }
        }
    },
    name: {
        required: true,
        type: 'string',
        async asyncValidator(_rule, value: string) {
            if (!value) {
                throw new Error('必须设置话题名称');
            }
            const database = _app.server.database();
            const result = await database.collection('topics').where({ 'name': value }).count();
            if (result.total) {
                throw new Error('话题已经存在');
            }
        }
    },
    description: {
        required: true,
        type: 'string',
        message: "必须设置话题描述",
    },
    title: {
        required: true,
        type: 'string',
        message: '必须设置话题关注者称谓',
    },
    joinType: {
        required: false,
        type: 'enum',
        enum: ['freely', 'examine'],
        message: '加入类型不合法',
    },
    postType: {
        required: false,
        type: 'enum',
        enum: ['any', 'text', 'image', 'audio', 'video'],
        message: '允许发布的动态类型不合法',
    },
};
const validator = new Schema(descriptor);

async function handler(app: App) {
    const { uid: creatorUserId } = await queryCurrentUser(app);
    const { cover, title, description, name, joinType = 'freely', postType = 'any' } = app.event.data;
    const database = app.server.database();

    const result = await database.collection('topics').add({ corator_id: creatorUserId, name, description, title, cover, joinType, postType  });

    return !!result.id;
}

export function createTopicCommand(app: App) {
    _app = app;

    return new Promise<any>(function (resolve, reject) {
        validator.validate(app.event.data, { first: true })
            .then(() => {
                handler(app).then(resolve).catch(reject);
            })
            .catch(({ errors, fields }) => {
                console.log(errors, fields, app.event.data);
                const error = errors.pop() as ValidateError;
                reject(error.message);
            });
    });
}
