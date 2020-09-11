import * as express from 'express';
import * as  serverless from 'serverless-http';
import { AbstractHttpAdapter, NestFactory } from "@nestjs/core";
import { ExpressAdapter, NestExpressApplication } from '@nestjs/platform-express';
import { AppModule } from "./app.module";
import { INestApplication, NestApplicationOptions } from '@nestjs/common';

export interface CreateAppOptions extends NestApplicationOptions {
    adapter?: AbstractHttpAdapter,
}

export async function createApp<T extends INestApplication>(options: CreateAppOptions = {}): Promise<T> {
    if (options && options.adapter instanceof AbstractHttpAdapter) {
        return await NestFactory.create<T>(AppModule, options.adapter, options);
    }

    return await NestFactory.create<T>(AppModule, options);
}

let expressApp: express.Express;
export async function createExpressApp(options: NestApplicationOptions = {}): Promise<express.Express> {
    if (expressApp) {
        return expressApp;
    }
    
    expressApp = express();
    const adapter = new ExpressAdapter(expressApp);
    const app = await createApp<NestExpressApplication>({
        adapter,
        ...options,
    });
    await app.init();

    return expressApp;
}

export async function createFnApp(event: any, context: any) {
    const app = await createExpressApp();
    const mock = serverless(app);
    
    return await mock(event, context);
}