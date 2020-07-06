const { verifyCode } = require("./verify-code");
const config = require("../config");

async function resolveUser(app, phone) {
    const database = app.database();
    const command = database.command;

    try {
        const result = await database.collection(config.userCollection)
            .where({
                phone: command.eq(phone),
            })
            .get();
        const user = result.data.pop();
        
        if (! user) {
            throw new Error();
        }

        return user;
    } catch (error) {
        const doc = {phone};
        const result = await database.collection(config.userCollection).add(doc);
        if (! result.code) {
            return { ...doc, _id: result.id };
        }


        throw new Error('Create user error.');
    }
}

async function withCodeLogin(app, payload) {
    const { phone } = payload;
    const verify = await verifyCode(app, payload);
    if (verify != true) {
        throw new Error("Code error");
    }

    const user = await resolveUser(app, phone);

    return app.auth().createTicket(user._id);
}

module.exports = { withCodeLogin };
