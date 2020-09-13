import { Injectable, NestMiddleware } from "@nestjs/common";
import { Request, Response } from "express";

@Injectable()
export class HttpMiddleware implements NestMiddleware<Request, Response> {
    use(_request: Request, response: Response, next: VoidFunction): void {
        response.setHeader('X-Powered-By', 'Fans Server; https://github.com/bytegem/fans');
        next();
    }
}
