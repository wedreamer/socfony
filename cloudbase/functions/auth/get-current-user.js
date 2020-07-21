async function privateResolver(app, user) {
    const database = app.database();
    const { _id: userId, private: privateId } = user;

    let privateUser;
    if (privateId) {
        const result = await database.collection('users-private').doc(privateId).get();

        privateUser = result.data.pop();
    }

    if (!privateUser) {
        const result = await database.collection('users-private').where({userId}).get();

        privateUser = result.data.pop();
    }

    if (!privateUser) {
        privateUser = {userId, createdAt: new Date, updatedAt: new Date};
        const result = await database.collection('users-private').add(privateUser);
        if (!result.code) {
            throw new Error('获取失败');
        }

        privateUser = {...privateUser, _id: result.id};
    }

    if (privateId != privateUser._id) {
        await database.collection('users').doc(userId).update({
            private: privateUser._id,
        });
    }
}

async function getCurrentUser(app, payload) {
    const auth = app.auth();
    const database = app.database();

    const { uid, customUserId, isAnonymous } = auth.getUserInfo();
    
    if ((!uid && !customUserId) || isAnonymous === true) {
        throw new Error('请先登录');
    }

    let user;
    if (customUserId) {
        const result = await database.collection('users').doc(customUserId).get();
        user = result.data.pop();
    }

    if (!user && uid) {
        const result = await database.collection('users').where({uid}).get();
        user = result.data.pop();
    }

    if (!user) {
        user = {uid, createdAt: new Date, updatedAt: new Date};
        const result = await database.collection('users').add(user);
        if (result.code) {
            throw new Error('获取失败');
        }

        user = {...user, _id: result.id};
    }

    if (!user.uid) {
        await database.collection('users').doc(user._id).update({uid});
        user = {...user, uid};
    }

    privateResolver(app, user);

    return user;
}

module.exports = { getCurrentUser };