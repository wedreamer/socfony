const config = require('../config');

async function verifyCode(app, payload) {
    const database = app.database();
    const command = database.command;
    const { phone, code } = payload;

    const result = await database.collection(config.codeCollection)
        .where({
            phone: command.eq(phone),
            code: command.eq(code),
            expiredAt: command.gte(new Date())
        })
        .get()
    ;

    return !!result.data.length;
}

module.exports = { verifyCode };
