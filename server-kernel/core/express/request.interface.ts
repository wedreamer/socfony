import { Request as ExpressRequest } from 'express';
import { AppContext } from '../../core';

export interface Request
  extends Pick<AppContext, 'authorizationToken' | 'user'>,
    ExpressRequest {
  context: AppContext;
}
