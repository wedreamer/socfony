import { Request as ExpressRequest } from 'express';
import { AppContext } from 'server-kernel/core/app.context';

export interface Request
  extends Pick<AppContext, 'authorizationToken' | 'user'>,
    ExpressRequest {
  context: AppContext;
}
