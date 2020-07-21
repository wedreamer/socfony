const cloudbase = require('@cloudbase/node-sdk');
const { getCurrentUser } = require('./get-current-user');

module.exports.main = async (event, context) => {
    const app = cloudbase.init({
        env: context.namespace,
    });
    const { action, payload } = event;

    switch (action) {
        case "getCurrentUser":
            return await getCurrentUser(app, payload);
    }
}
