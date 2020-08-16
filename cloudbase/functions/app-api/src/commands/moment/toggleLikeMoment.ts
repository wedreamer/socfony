import { App } from "../../app";
import queryCurrentUser from "../user/queryCurrentUser";
import Schema, { Rules, ValidateError } from "async-validator";

const descriptor: Rules = {
    momentId: { type: 'string', required: true, message: '请传入需要操作的动态ID' },
};
const validator = new Schema(descriptor);

async function handler(app: App) {
    await validator.validate(app.event.data);

    const { uid: userId } = await queryCurrentUser(app);
    const { momentId } = app.event.data;
    const database = app.server.database();
    const command = database.command;
    const collection = database.collection('moment-liked-histories')
    const action = collection.where({ userId, momentId });
    const moment = database.collection('moments').doc(momentId);

    const result = await action.count();
        
    if (result.total) {
        moment.update({
            'count.like': command.inc(-1),
        });
        return action.remove();
    }

    collection.add({ userId, momentId, createdAt: new Date, updatedAt: new Date });
    moment.update({
        'count.like': command.inc(1),
    });
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