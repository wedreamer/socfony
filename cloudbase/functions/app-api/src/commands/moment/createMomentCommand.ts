import { App } from "../../app";
import queryCurrentUser from "../user/queryCurrentUser";

import Schema, { Rules, ValidateError } from "async-validator";
import lodash from 'lodash';
import { getCloudFilePath } from "../../utils/managerFilePathUtil";

let _app: App;

const descriptor: Rules = {
    text: { type: 'string', required: true, message: '动态内容不能为空', },
    images: [
        { type: 'array', required: false, min: 1, max: 9, defaultField: {
            type: 'string',
            required: true,
            async asyncValidator(_, value: string) {
                const manager = _app.manager;
                const file = await manager.storage.getFileInfo(getCloudFilePath(value));
                const hasMatch =  file.Type.match('image/*') != null;
                if (!hasMatch) {
                    throw new Error('上传的图片不合法');
                }
            }
        }, },
    ],
    video: {
        type: "object",
        required: false,
        fields: {
            src: { type: 'string', required: true, async asyncValidator(_, value: string) {
                const manager = _app.manager;
                const file = await manager.storage.getFileInfo(getCloudFilePath(value));
                const hasMatch =  file.Type.match('video/*') != null;
                if (!hasMatch) {
                    throw new Error('上传的视频不合法');
                }
            }, },
            cover: {
                type: 'string',
                required: true,
                async asyncValidator(_, value: string) {
                    const manager = _app.manager;
                    const file = await manager.storage.getFileInfo(getCloudFilePath(value));
                    const hasMatch =  file.Type.match('image/*') != null;
                    if (!hasMatch) {
                        throw new Error('上传的视频封面不合法');
                    }
                }
            },
        },
    },
    audio: {
        type: "object",
        required: false,
        fields: {
            cover: {
                type: 'string',
                required: false,
                async asyncValidator(_, value: string) {
                    const manager = _app.manager;
                    const file = await manager.storage.getFileInfo(getCloudFilePath(value));
                    const hasMatch =  file.Type.match('image/*') != null;
                    if (!hasMatch) {
                        throw new Error('上传的音频封面不合法');
                    }
                },
            },
            src: {
                type: 'string',
                required: true,
                async asyncValidator(_, value: string) {
                    const manager = _app.manager;
                    const file = await manager.storage.getFileInfo(getCloudFilePath(value));
                    const hasMatch =  file.Type.match('audio/*') != null;
                    if (!hasMatch) {
                        throw new Error('上传的音频不合法');
                    }
                },
            },
        },
    },
    vote: {
        type: 'array',
        required: false,
        message: '投票选项不合法',
        defaultField: {
            type: 'string',
            required: true,
            message: '投票选项不能存在空值',
        },
    },
    location: {
        type: 'object',
        required: false,
        fields: {
            longitude: { type: 'number', required: true, },
            latitude: { type: 'number', required: true, },
        },
    }
};
const validator = new Schema(descriptor);

interface MomentDoc {
    userId: string,
    createdAt?: Date,
    text: string,
    audio?: {
        src: string,
        cover?: string,
    },
    images?: string[],
    video?: {
        src: string,
        cover: string,
    },
    vote?: {
        name: string,
        count?: number,
    }[],
    location?: any,
}

async function createMoment(app: App) {
    const { uid: userId } = await queryCurrentUser(app);
    
    const { text, audio, images, video, vote, location } = app.event.data;
    const database = app.server.database();
    
    let doc: MomentDoc = {
        userId,
        text, audio, images, video,
    };
    if (vote && Array.isArray(vote)) {
        doc.vote = lodash.uniq(vote).map(value => ({
            name: value
        }));
    }

    if (location && location.longitude && location.latitude) {
        doc.location = new database.Geo.Point(location.longitude, location.latitude);
    }

    doc = lodash.omitBy<MomentDoc>(doc, lodash.isEmpty) as MomentDoc;
    doc.createdAt = new Date();

    const result = await database.collection('moments').add(doc);

    return !!result.id;
}

export default function(app: App) {
    _app = app;

    return new Promise<any>(function (resolve, reject) {
        validator.validate(app.event.data, { first: true }, function(errors) {
            if (errors) {
                const error = errors.pop() as ValidateError;
                return reject(error.message);
            }

            return createMoment(app).then(resolve).catch(reject);
        });
    });
}