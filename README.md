# Fans

<img src="assets/fans.svg" align="right" width="120" />

Fans 是一个基于 CloudBase 而开发的 Serverless 云原生一体化产品方案程序，主要致力于开源社交程序。

- [x] 基于 Flutter 的移动端 App
- [x] 基于 CloudBase 的服务端相关组件
- [ ] 微信小程序
- [ ] QQ 小程序

## 快速开始

要开始部署 Fans 你可能需要掌握 Dart & Flutter 以及 Node.js 相关的既能

- Node.js 编写云函数的服务代码
- Flutter 编写 App 的逻辑及界面代码

### 部署项目到 CloudBase

首选你需要登录到腾讯云平台，开通 CloudBase 云开发服务，然后创建一个默认环境。

然后复制项目根的 `.fansrc.example` 文件为 `.fansrc` 文件，文件内容及配置如下：

| Key | 类型 | 描述 |
|:----------|:----------:|:------------|
| TENCENTCLOUD_SECRETID | String | 腾讯云访问 ID，仅本地开发云函数服务代码需要配置 |
| TENCENTCLOUD_SECRETKEY | String | 腾讯云访问 Key，仅本地开发云函数服务代码需要配置 |
| ENV_ID ｜ String | 腾讯云 CloudBase 云开发的环境 ID |
| __DEV_MOCK_TCB_UUID | String | 本地开发云函数服务代码时用来模拟已登陆用户的用户 ID |

然后需要在心目中执行如下代码：

- `npm install` 进行工具链的依赖安装
- `npm run lerna bpptstrap` 进行 `packages` 相关依赖的 Mock

然后运行 `npm run fansrc` 进行项目配置文件生成，接下就是将相关服务部署到 CloudBase 环境了，
运行 `npm run server:dev` 即可。

现在你进入 CloudBase 环境里面，点击[云函数] 会出现一个名为 `server` 的云函数，即代表安装成功

先别着急，你还需要点击进入 **云调用** 里面安装短信拓展，这样才能进行用户登录哦

### 编译 App

前提是你需要本地已经安装完 Flutter 的工具。

现在打开 `lib/config.dart` 进行 App 的配置，配置完成后运行 `flutter run` 即可在你的设备商看到 Fans 客户端了，打开后可正常使用！
