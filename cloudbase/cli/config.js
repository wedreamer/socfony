const fs = require('fs');
const { rootPathResolve } = require('./path-resolve');
const config = require(rootPathResolve('snsmaxrc'));
const customLoginKey = require(rootPathResolve("custom-login-key"));

module.exports = {
    ...config,
    customLoginKey,
    envId: customLoginKey.env_id,
};
