import Schema, { Rules, ValidateError } from 'async-validator';

import { App } from "../../app";
import queryCurrentUser from "./queryCurrentUser";

const descriptor: Rules = {
    uid: {
        required: true,
        type: 'string',
    }
};
const validator = new Schema(descriptor);

async function handler(app: App) {
    const currentUser = await queryCurrentUser(app);
    const { uid } = app.event.data;

    if (currentUser.uid == uid) {
        return currentUser;
    }

    const auth = app.server.auth();
    const { nickName, gender, country, province, city, avatarUrl } = (await auth.getEndUserInfo(uid)).userInfo;

    return {
        nickName, gender, country, province, city, avatarUrl, uid,
    }
}

export default function(app: App) {
    return new Promise<any>((resolve, reject) => {
        validator.validate(app.event.data, { first: true }, errors => {
            if (errors) {
                const error = errors.pop() as ValidateError;
                return reject(error.message);
            }

            return handler(app).then(resolve).catch(reject);
        });
    });
}