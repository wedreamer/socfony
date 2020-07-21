const { cloudBasePathResolve } = require("./path-resolve");
const { readdirSync } = require("fs");

const functionsPathResolve = (...p) => cloudBasePathResolve("functions", ...p);

const functionsBuilder = (config) => {
    const functions = readdirSync(functionsPathResolve());
    return functions.map(name => {
        const functionConfig = require(functionsPathResolve(name, 'deployrc'))(config);
        let ignore = functionConfig.ignore;
        if (!ignore) {
            ignore = [];
        }
        ignore = [...ignore, 'deployrc.js'];

        return {
            ...functionConfig,
            name,
            ignore
        };
    });
};

module.exports = { functionsBuilder };
