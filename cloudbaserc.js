module.exports = {
    envId: "snsmax-1e572d",
    functionRoot: "./cloudbase/functions",
    functions: [
        /// Client
        require('./cloudbase/functions/app-api/.function'),
    ],
};

console.log(module.exports);
