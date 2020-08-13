module.exports = {
    name: "app-api",
    handler: "index.main",
    runtime: "Nodejs10.15",
    installDependency: true,
    timeout: 10,
    ignore: [
        "src",
        "src/**/*",
        ".function.js",
        "rollup.config.js",
        // 忽略 node_modules 文件夹
        "node_modules",
        "node_modules/**/*",
    ],
};
