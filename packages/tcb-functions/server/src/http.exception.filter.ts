import { ArgumentsHost, Catch, ExceptionFilter, HttpException, } from "@nestjs/common";
import { Response } from "express";

@Catch(HttpException)
export class HttpExceptionFilter implements ExceptionFilter<HttpException>  {
    catch(exception: HttpException, host: ArgumentsHost) {
        const http = host.switchToHttp();
        const response = http.getResponse<Response>();
        const statusCode = exception.getStatus();
        const data = exception.getResponse();

        response.status(exception.getStatus())
            .json({
                statusCode,
                ...(data instanceof Array ? { 'errors': data } : {}),
                ...(typeof data == 'string' ? { message: data } : {}),
                ...((data as object) || {}),
            });
    }
}
