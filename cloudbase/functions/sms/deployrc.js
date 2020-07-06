module.exports = (config) => ({
    timeout: 10,
    runtime: "Nodejs10.15",
    installDependency: true,
    handler: "index.main",
    ignore: [
        "node_modules",
        "package-lock.json",
    ],
    envVariables: {
        smsAppId: config.sms.appId,
        smsSign: config.sms.sign,
        smsTemplate: config.sms.template,
        smsCodeExpiredTime: config.sms.codeExpiredTime.toString(),
        customLoginKey: JSON.stringify(config.customLoginKey),
    },
});
