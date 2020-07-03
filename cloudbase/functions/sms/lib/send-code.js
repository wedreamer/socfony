const config = require('../config');
const { Client, Models } = require('tencentcloud-sdk-nodejs/tencentcloud/sms/v20190711');
const { Credential } = require('tencentcloud-sdk-nodejs/tencentcloud/common');
const { randomStr } = require('./utils');

async function createCode(app, payload) {
    const database = app.database();
    const { phone } = payload;

    await database.collection(config.codeCollection)
        .where({phone})
        .remove()
    ;

    const code = randomStr(6);
    const expiredAt = new Date();
    expiredAt.setTime(Date.now() + (5 * 60 * 1000));

    const doc = {phone, code, expiredAt};

    await database.collection(config.codeCollection).add(doc);

    return code;
}

async function sendCode(app, payload) {
    const code = await createCode(app, payload);

    const {
        TENCENTCLOUD_SECRETID,
        TENCENTCLOUD_SECRETKEY,
        TENCENTCLOUD_SESSIONTOKEN,
        TENCENTCLOUD_REGION,
    } = process.env;
    const cred = new Credential(TENCENTCLOUD_SECRETID, TENCENTCLOUD_SECRETKEY, TENCENTCLOUD_SESSIONTOKEN);
    const client = new Client(cred, TENCENTCLOUD_REGION);
    const request = new Models.SendSmsRequest();
    
    request.SmsSdkAppid = config.app.appId;
    request.Sign = config.app.sign;
    request.TemplateID = config.app.templateId;

    const { phone } = payload;

    request.PhoneNumberSet = [`+86${phone}`];
    request.TemplateParamSet = [code, "5"];

    return new Promise((resolve, reject) => {
        client.SendSms(request, (error, response) => {
            if (error) {
                return reject(error);
            }

            const json = JSON.parse(response.to_json_string());
            if (json.SendStatusSet[0].Code.toLowerCase() === 'ok') {
                return resolve();
            }

            return reject(new Error(json.SendStatusSet[0].Message));
        });
    });
};

module.exports = {
    sendCode
};
