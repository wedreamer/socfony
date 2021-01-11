import { CanActivate, ExecutionContext, Injectable } from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { Request } from 'express';
import { UNAUTHENTICATION } from 'src/constants';
import { resolveAppExecutionContext } from 'src/helper';
import { AuthorizationService } from './authorization.service';

@Injectable()
export class AuthGuard implements CanActivate {
  constructor(
    private readonly authorizationService: AuthorizationService,
    private readonly reflector: Reflector,
  ) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
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

    const type = this.reflector.get<'auth' | 'refresh'>(
      'validate-authorization-type',
      context.getHandler(),
    );
    const hasTokenExpired = await this.authorizationService.hasTokenExpired(
      appContext.authorizationTokenClient,
      type,
    );
    if (hasTokenExpired) {
      throw new Error(UNAUTHENTICATION);
    }

    appContext.hasLogged = !hasTokenExpired;
    appContext.request.hasLogged = appContext.hasLogged;

    return appContext.hasLogged;
  }
}
