import { CanActivate, ExecutionContext, Injectable } from '@nestjs/common';
import { Observable } from 'rxjs';
import { AuthorizationService } from './authorization.service';

@Injectable()
export class AuthGuard implements CanActivate {
  constructor(private readonly authorizationService: AuthorizationService) {}

  canActivate(
    context: ExecutionContext,
  ): boolean | Promise<boolean> | Observable<boolean> {
    const request = context.switchToHttp().getRequest();
    if (request) {
      this.authorizationService.resolveHttpContext(request);
    }

    return true;
  }
}
