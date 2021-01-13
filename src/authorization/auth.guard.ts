import {
  CanActivate,
  ExecutionContext,
  Injectable,
  UnauthorizedException,
} from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { Request } from 'express';
import { UNAUTHORIZED } from 'src/constants';
import { resolveAppExecutionContext } from 'src/helper';
import { AuthorizationService } from './authorization.service';

/**
 * HTTP endpoint Authorization guard.
 */
@Injectable()
export class AuthGuard implements CanActivate {
  constructor(
    private readonly authorizationService: AuthorizationService,
    private readonly reflector: Reflector,
  ) {}

  /**
   * Can activate for HTTP endpoint `Authorization` token.
   * @param context NestJS context
   */
  async canActivate(context: ExecutionContext): Promise<boolean> {
    // If contex is HTTP context, resolve app context.
    if (context.getType() === 'http') {
      this.authorizationService.resolveHttpContext(
        context.switchToHttp().getRequest<Request>(),
      );
    }

    // get and resolve app context.
    const appContext = resolveAppExecutionContext(context);

    // get authorization validate set.
    const hasAuthorization = this.reflector.get<boolean>(
      'validate-authorization',
      context.getHandler(),
    );

    // If Don't validate or verified
    if (!hasAuthorization || appContext.hasLogged) {
      return true;
    }

    // get `Authorization` token validate type
    const type = this.reflector.get<'auth' | 'refresh'>(
      'validate-authorization-type',
      context.getHandler(),
    );

    // validate `Authorization` token
    const hasTokenExpired = await this.authorizationService.hasTokenExpired(
      appContext.authorizationTokenClient,
      type,
    );

    // If `Authorization` token is expired throw a Unauthorized code message.
    if (hasTokenExpired) {
      throw new Error(UNAUTHORIZED);
    }

    // Set hasLogged to app context
    appContext.hasLogged = !hasTokenExpired;
    appContext.request.hasLogged = appContext.hasLogged;

    return appContext.hasLogged;
  }
}
