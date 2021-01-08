import { CanActivate, ExecutionContext, Injectable } from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { Request } from 'express';
import { resolveAppExecutionContext } from 'src/helper';
import { AuthorizationService } from './authorization.service';

@Injectable()
export class AuthGuard implements CanActivate {
  constructor(
    private readonly authorizationService: AuthorizationService,
    private readonly reflector: Reflector,
  ) {}

  async canActivate(
    context: ExecutionContext,
  ): Promise<boolean> {
    let request = context.switchToHttp().getRequest<Request>();
    if (context.getType() === 'http') {
      this.authorizationService.resolveHttpContext(
        context.switchToHttp().getRequest<Request>(),
      );
    }
    const appContext = resolveAppExecutionContext(context);

    const hasAuthorization = this.reflector.get<boolean>(
      'validate-authorization',
      context.getHandler(),
    );
    if (!hasAuthorization || appContext.hasLogged) {
      return true;
    }

    const hasTokenExpired = await this.authorizationService.hasTokenExpired(
      appContext.authorizationToken,
      'auth',
    );
    appContext.hasLogged = !hasTokenExpired
    appContext.request.hasLogged = appContext.hasLogged;

    return appContext.hasLogged;
  }
}
