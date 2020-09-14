import { config as dotenvConfig } from 'dotenv';
import { Request } from 'express';
import { createApp } from "./app";
import { removeMockedFunctionAuthEnv, setMockTcbFunctionAuthEnv } from './utils/cloudbase.util';

// 配置环境变量
dotenvConfig();

const bootstrap = async () => {
    const app = await createApp();

    // 构造虚拟的已认证用户
    app.use((request: Request, _: any, next: VoidFunction) => {
        const { _m, _rm } = request.query;
        if (_m != undefined || _m != null) {
            setMockTcbFunctionAuthEnv(process.env.__DEV_MOCK_TCB_UUID);
        }

        if (_rm != undefined || _rm != null) {
            removeMockedFunctionAuthEnv();
        }

        next();
    });

    const port = 3000;
    app.listen(port, () => console.log(`http://127.0.0.1:${port}`));
};

bootstrap();
