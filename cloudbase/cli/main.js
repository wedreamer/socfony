const { cloudBasePathResolve } = require("./path-resolve");
const config = require("./config");
const { functionsBuilder } = require("./functions-builder");

const runCloudBase = () => {
    const app = {
        envId: config.envId,
        functionRoot: cloudBasePathResolve("functions"),
        functions: functionsBuilder(config),
    };

    return app;
};

module.exports = { runCloudBase };
