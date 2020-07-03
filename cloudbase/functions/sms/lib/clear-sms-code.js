const config = require('../config');

exports.clearSmsCode = (app) => {
    const database = app.database();
    const command = database.command;
    database.collection(config.codeCollection)
        .where({
            expiredAt: command.lt(Date.now())
        })
        .remove()
    ;
};
