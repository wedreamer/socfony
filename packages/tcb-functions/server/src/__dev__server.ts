import { config as dotenvConfig } from 'dotenv';
import { Request } from 'express';
import { createApp } from "./app";

// 配置环境变量
dotenvConfig();

console.log(process.env);

const bootstrap = async () => {
    const app = await createApp();

    // 构造虚拟的已认证用户
    app.use((request: Request, _: any, next: VoidFunction) => {
        const { _m, _rm } = request.query;
        if (_m != undefined || _m != null) {
            const keys = (process.env.TCB_CONTEXT_KEYS || '')
                .split(',')
                .filter(value => value != 'TCB_UUID');
            keys.push('TCB_UUID');

            process.env.TCB_CONTEXT_KEYS = keys.filter(v => !!v).join(',');
            process.env.TCB_UUID = process.env.__DEV_MOCK_TCB_UUID;
        }

        if (_rm != undefined || _rm != null) {
            process.env.TCB_UUID = undefined;
            const keys = (process.env.TCB_CONTEXT_KEYS || '').split(',');
            process.env.TCB_CONTEXT_KEYS = keys.filter(value => value != 'TCB_UUID').filter(v => !!v).join(',');
        }

        next();
    });

    const port = 3000;
    app.listen(port, () => console.log(`http://127.0.0.1:${port}`));
};

bootstrap();
