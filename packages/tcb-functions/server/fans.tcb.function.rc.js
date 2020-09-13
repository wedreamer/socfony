const { name } = require('./package.json');

module.exports = {
    name: name,
    timeout: 10,
    runtime: 'Nodejs10.15',
    installDependency: true,
    handler: 'index.main',
    ignore: [
        // 忽略环境文件
        ".env",
        // 忽略 markdown 文件
        "*.md",
        // 忽略 node_modules 文件夹
        "node_modules",
        "node_modules/**/*",
        // 忽略 TypeScript 源文件，不需要安装时候编译
        "src",
        "src/**/*",
        // 忽略 npm 锁文件，避免系统不一致所导致的云函数安装失败
        'package-lock.json',
        // 忽略脚本文件
        "scripts",
        "scripts/*"
    ],
};
