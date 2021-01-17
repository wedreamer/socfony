import { ExecutionContext, Injectable } from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { AppContext, AppContextService, Request } from '~core';
import { AuthService } from './auth.service';
import {
  AUTH_METADATA_HAS_AUTHORIZATION,
  AUTH_METADATA_HAS_AUTHORIZATION_TYPE,
} from './constants';
import { HasTokenExpiredType } from './enums';

@Injectable()
export class AuthGuard {
  constructor(
    private readonly reflector: Reflector,
    private readonly appContextService: AppContextService,
    private readonly authService: AuthService,
  ) {}

  /**
   * Can activate for HTTP endpoint `Authorization` token.
   * @param context NestJS context
   */
  async canActivate(context: ExecutionContext): Promise<boolean> {
    // If contex is HTTP context, resolve app context.
    if (context.getType() === 'http') {
      this.appContextService.createContext(
        context.switchToHttp().getRequest<Request>(),
      );
    }

    // get authorization validate set.
    const hasAuthorization = this.reflector.get<boolean>(
      AUTH_METADATA_HAS_AUTHORIZATION,
      context.getHandler(),
    );

    // If Don't validate or verified
    if (!hasAuthorization) return true;

    // get `Authorization` token validate type
    const type = this.reflector.get<HasTokenExpiredType>(
      AUTH_METADATA_HAS_AUTHORIZATION_TYPE,
      context.getHandler(),
    );

    return this.canActivelyTokenHandler(
      this.appContextService.resolve(context),
      type || HasTokenExpiredType.AUTH,
    );
  }

  private canActivelyTokenHandler(
    context: AppContext,
    type: HasTokenExpiredType,
  ): boolean {
    const { authorizationToken, user } = context;

    return user && this.authService.hasTokenExpired(authorizationToken, type);
  }
}
