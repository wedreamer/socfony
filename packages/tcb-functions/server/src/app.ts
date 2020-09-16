import express from 'express';
import serverless from 'serverless-http';
import { AbstractHttpAdapter, NestFactory } from "@nestjs/core";
import { ExpressAdapter, NestExpressApplication } from '@nestjs/platform-express';
import { AppModule } from "./app.module";
import { INestApplication, NestApplicationOptions } from '@nestjs/common';

export interface CreateAppOptions extends NestApplicationOptions {
    adapter?: AbstractHttpAdapter,
}

export async function createApp<T extends INestApplication>(options: CreateAppOptions = {}): Promise<T> {
    const getApp = async (): Promise<T> => {
        if (options && options.adapter instanceof AbstractHttpAdapter) {
            return await NestFactory.create<T>(AppModule, options.adapter, options);
        } 
    
        return await NestFactory.create<T>(AppModule, options);
    };
    const app = await getApp();

    return app;
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
    console.log(event, context);
    const getRunner = async () => {
        const app = await createExpressApp();

        return serverless(app);
    }
    const runner = await getRunner();
    
    return await runner(event, context);
}