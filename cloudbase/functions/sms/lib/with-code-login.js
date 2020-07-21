const { verifyCode } = require("./verify-code");
const config = require("../config");

async function resolveUser(app, phone) {
    const database = app.database();

    let privateResult = await database.collection(config.userPrivateCollection).where({phone}).get();
    let privateUser = privateResult.data.pop();
    if (!privateUser) {
        privateUser = {phone, createdAt: new Date, updatedAt: new Date};
        const result = await database.collection(config.userPrivateCollection).add(privateUser);
        if (result.code) {
            throw new Error("创建用户失败");
        }
        console.log(privateUser, result);
        privateUser = {...privateUser, _id: result.id};
    }

    let user;
    if (privateResult.userId) {
        const result = await database.collection(config.userCollection).where({userId: privateResult.userId}).get();
        user = result.data.pop();
    }

    if (! user) {
        user = {private: privateUser._id, createdAt: new Date, updatedAt: new Date};
        const result = await database.collection(config.userCollection).add(user);
        if (result.code) {
            throw new Error("创建用户失败");
        }
        user = {...user, _id: result.id};
    }

    await database.collection(config.userPrivateCollection).doc(privateUser._id).update({userId: user._id, updatedAt: new Date});

    return user;
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
