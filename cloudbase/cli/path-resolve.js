const { resolve } = require("path");

const rootPathResolve = (...p) => resolve(__dirname, '../../', ...p);
const cloudBasePathResolve = (...p) => rootPathResolve('cloudbase', ...p);

module.exports = { rootPathResolve, cloudBasePathResolve };
