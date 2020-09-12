import { Plugin, PluginServiceApi } from '@cloudbase/framework-core';
import { IFrameworkPluginFunctionInputs } from '@cloudbase/framework-plugin-function';
import { plugin as FunctionPlugin } from "@cloudbase/framework-plugin-function";
import { CAccessOption, CPlugincInputs } from './inputs';

export class CloudBaseFrameworkNodeFunctionPlugin extends Plugin {
    private functionPlugin: Plugin;
    private access: CAccessOption[];

    constructor(
        public readonly name: string,
        public readonly api: PluginServiceApi,
        public readonly inputs: CPlugincInputs & IFrameworkPluginFunctionInputs,
    ) {
        super(name, api, inputs);
        this.functionPlugin = new FunctionPlugin(name, api, inputs);
        if (inputs.access && inputs instanceof Array) {
            this.access = inputs.access;
        }
    }

    async init(params: any) {
        await this.functionPlugin.init(params);
    }

    genCode?(params: any): Promise<any> {
        return this.functionPlugin.genCode(params);
    }
    
    build(params: any): Promise<any> {
        return this.functionPlugin.build(params);
    }

    async deploy(params: any) {
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
            this.api.logger.info(
                `${this.api.emoji("🚀")} 云接入服务发布成功，访问地址: ${url}`
            );
        }
    }

    compile?(params: any): Promise<any> {
        return this.functionPlugin.compile(params);
    }

    run?(params: any): Promise<any> {
        return this.functionPlugin.run(params);
    }

    remove?(params: any): Promise<any> {
        return this.functionPlugin.remove(params);
    }
}

export const plugin = CloudBaseFrameworkNodeFunctionPlugin;
