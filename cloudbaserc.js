const cli = {
    envId: "snsmax-1e572d",
    functionRoot: "./cloudbase/functions",
    functions: [
        /// Client
        require('app-api/.function'),
    ],
};

const framework = {
    name: 'Fans',
    plugins: {
        function: {
            use: "@cloudbase/framework-plugin-function",
            inputs: {
                functionRootPath: cli.functionRoot,
                functions: cli.functions,
            },
        },
        database: {
            use: '@cloudbase/framework-plugin-database',
            inputs: require('database'),
        }
    },
};

module.exports = { ...cli, framework };
