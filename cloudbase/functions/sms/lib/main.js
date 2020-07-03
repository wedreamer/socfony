const cloudbase = require('@cloudbase/node-sdk');
const { clearSmsCode } = require('./clear-sms-code');
const { sendCode } = require('./send-code');
const { verifyCode } = require('./verify-code');
const { withCodeLogin } = require('./with-code-login');
const config = require('../config');

exports.main = async (event, context) => {
    const app = cloudbase.init({
        env: context.namespace,
        credentials: config.customLoginKey,
    });
    
    // run Clear SMS codes
    clearSmsCode(app);

    const { action, ...payload } = event;

    switch (action) {
        case "send-code":
            return await sendCode(app, payload);
        case "verify-code":
            return verifyCode(app, payload);
        case "with-code-login":
            return withCodeLogin(app, payload);
    }

    throw new Error(`Don't support action: [${action}]`);
};
