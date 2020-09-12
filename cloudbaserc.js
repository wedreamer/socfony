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
  functionRoot: 'packages',
  functions: Object.values(functions),
};

// @cloudbase/framework 配置信息
const framework = {
  name: 'Fans',
  // // 暂不启用，手动添加服务地址
  // plugins: {
  //   server: {
  //     use: '@cloudbase/framework-plugin-node',
  //     inputs: {
  //       entry: 'index.js',
  //       path: '/service',
  //       name: functions.server.name,
  //       projectPath: 'packages/server',
  //       buildCommand: "npm run lerna -- run --scope server build",
  //       platform: 'function',
  //       functionOptions: functions.server,
  //     },
  //   },
  // },
};

module.exports = { ...cli, framework };
