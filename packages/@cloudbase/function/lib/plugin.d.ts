import { Plugin, PluginServiceApi } from '@cloudbase/framework-core';
import { IFrameworkPluginFunctionInputs } from '@cloudbase/framework-plugin-function';
import { CPlugincInputs } from './inputs';
export declare class CloudBaseFrameworkNodeFunctionPlugin extends Plugin {
    readonly name: string;
    readonly api: PluginServiceApi;
    readonly inputs: CPlugincInputs & IFrameworkPluginFunctionInputs;
    private functionPlugin;
    private access;
    constructor(name: string, api: PluginServiceApi, inputs: CPlugincInputs & IFrameworkPluginFunctionInputs);
    init(params: any): Promise<void>;
    genCode?(params: any): Promise<any>;
    build(params: any): Promise<any>;
    deploy(params: any): Promise<void>;
    compile?(params: any): Promise<any>;
    run?(params: any): Promise<any>;
    remove?(params: any): Promise<any>;
}
export declare const plugin: typeof CloudBaseFrameworkNodeFunctionPlugin;
