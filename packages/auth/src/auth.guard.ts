import { Reflector } from '@nestjs/core';
import { ExecutionContext, Injectable } from '@nestjs/common';
import { Context } from '@socfony/kernel';
import { AuthService } from './auth.service';
import {
  AUTH_METADATA_HAS_AUTHORIZATION,
  AUTH_METADATA_HAS_AUTHORIZATION_TYPE,
} from './constants';
import { HasTokenExpiredType } from './enums';
import { Request } from 'express';

@Injectable()
export class AuthGuard {
  constructor(
    private readonly reflector: Reflector,
    private readonly context: Context,
    private readonly authService: AuthService,
  ) {}

  initializeContext(context: ExecutionContext) {
    if (context.getType() === 'http') {
      this.context.create(
        context.switchToHttp().getRequest<Request>(),
      );
    }
  }

  getHasAuthorization(context: ExecutionContext) {
    return this.reflector.get<boolean>(
      AUTH_METADATA_HAS_AUTHORIZATION,
      context.getHandler(),
    );
  }

  getHasAuthorizationType(context: ExecutionContext) {
    return this.reflector.get<HasTokenExpiredType>(
      AUTH_METADATA_HAS_AUTHORIZATION_TYPE,
      context.getHandler(),
    );
  }

  /**
   * Can activate for HTTP endpoint `Authorization` token.
   * @param context NestJS context
   */
  async canActivate(context: ExecutionContext): Promise<boolean> {
    this.initializeContext(context);

    // If Don't validate or verified
    if (!this.getHasAuthorization(context)) return true;

    // get `Authorization` token validate type
    const type = this.getHasAuthorizationType(context);

    return this.canActivelyTokenHandler(
      type || HasTokenExpiredType.AUTH,
    );
  }

  private canActivelyTokenHandler(
    type: HasTokenExpiredType,
  ): boolean {
    const { authorizationToken, user } = this.context;

    return user && this.authService.hasTokenExpired(authorizationToken, type);
  }
}
