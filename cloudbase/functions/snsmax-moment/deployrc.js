module.exports = (config) => ({
    timeout: 10,
    runtime: "Nodejs10.15",
    installDependency: true,
    handler: "index.main",
    ignore: [
        "src/**/*",
        "src",
    ],
});
