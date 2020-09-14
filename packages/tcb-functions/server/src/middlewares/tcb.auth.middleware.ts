import { Injectable, NestMiddleware } from "@nestjs/common";
import { Request, Response } from "express";
import { removeMockedFunctionAuthEnv, setMockTcbFunctionAuthEnv } from "src/utils/cloudbase.util";

@Injectable()
export class TcbAuthMiddleware implements NestMiddleware<Request, Response> {
    use(request: Request, response: Response, next: VoidFunction) {
        try {
            const credentials = this.getCloudBaseCredentils(request);
            const userId = this.getUserId(credentials);
            // 先移除，以为是常驻运行，环境变量会被缓存
            removeMockedFunctionAuthEnv();

            // 设置模拟 TCB 环境的用户信息
            setMockTcbFunctionAuthEnv(userId);
        } catch {}

        next();
    }

    private getUserId(jwtToken: string): string  {
        const [_, payloadString] = jwtToken.split('.');
        const payload = Buffer.from(payloadString, 'base64').toString();
        const { data } = JSON.parse(payload);
        const { uuid, loginType } = JSON.parse(data);

        // 匿名用户判定为未登录
        if (loginType == 'ANONYMOUS') {
            return null;
        }
        
        return uuid;
    }

    private getCloudBaseCredentils(request: Request): string {
        const credentials = request.header('x-cloudbase-credentials');
        if (Array.isArray(credentials) && credentials.length) {
            return credentials.pop();
        }

        return credentials;
    }
}
