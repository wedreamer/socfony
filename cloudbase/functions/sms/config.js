const {
    smsAppId,
    smsSign,
    smsTemplate,
    smsCodeExpiredTime,
    customLoginKey,
} = process.env;

module.exports = {
    codeCollection: "-sms-auth-code",
    userCollection: "users",
    sms: {
        appId: smsAppId,
        sign: smsSign,
        templateId: smsTemplate,
        codeExpiredTime: parseInt(smsCodeExpiredTime),
    },
    customLoginKey: JSON.parse(customLoginKey),
};
