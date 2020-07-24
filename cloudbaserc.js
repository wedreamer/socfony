const { runCloudBase } = require("./cloudbase/cli/main.js");
const app = runCloudBase();

console.log(app['functions']);

module.exports = app;
