"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.plugin = exports.CloudBaseFrameworkNodeFunctionPlugin = void 0;
const framework_core_1 = require("@cloudbase/framework-core");
const framework_plugin_function_1 = require("@cloudbase/framework-plugin-function");
class CloudBaseFrameworkNodeFunctionPlugin extends framework_core_1.Plugin {
    constructor(name, api, inputs) {
        super(name, api, inputs);
        this.name = name;
        this.api = api;
        this.inputs = inputs;
        this.functionPlugin = new framework_plugin_function_1.plugin(name, api, inputs);
        if (inputs.access && inputs instanceof Array) {
            this.access = inputs.access;
        }
    }
    async init(params) {
        await this.functionPlugin.init(params);
    }
    genCode(params) {
        return this.functionPlugin.genCode(params);
    }
    build(params) {
        return this.functionPlugin.build(params);
    }
    async deploy(params) {
        await this.functionPlugin.deploy(params);
        for (const value of this.access) {
            await this.api.cloudbaseManager.access.deleteAccess({
                name: value.function,
                type: 1,
            });
            await this.api.cloudbaseManager.access.deleteAccess({
                path: value.path,
            });
            await this.api.cloudbaseManager.access.createAccess({
                name: value.function,
                path: value.path,
                type: 1,
                auth: value.auth || false,
            });
            let url = `https://${this.api.envId}.service.tcloudbase.com${value.path}}`;
            if (url[url.length - 1] !== "/") {
                url = url + "/";
            }
            url = this.api.genClickableLink(url);
            this.api.logger.info(`${this.api.emoji("🚀")} 云接入服务发布成功，访问地址: ${url}`);
        }
    }
    compile(params) {
        return this.functionPlugin.compile(params);
    }
    run(params) {
        return this.functionPlugin.run(params);
    }
    remove(params) {
        return this.functionPlugin.remove(params);
    }
}
exports.CloudBaseFrameworkNodeFunctionPlugin = CloudBaseFrameworkNodeFunctionPlugin;
exports.plugin = CloudBaseFrameworkNodeFunctionPlugin;
//# sourceMappingURL=plugin.js.map