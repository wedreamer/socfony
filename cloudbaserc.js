const functions = {
  server: {
    name: 'server',
    timeout: 10,
    runtime: 'Nodejs10.15',
    installDependency: true,
    handler: 'index.main',
    ignore: [
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
    ],
  }
};

// CloudBase CLI 配置信息
const cli = {
  envId: "snsmax-1e572d",
  functionRoot: 'packages/tcb-functions',
  functions: Object.values(functions),
};

module.exports = cli;
