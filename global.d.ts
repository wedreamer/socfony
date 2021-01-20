import { Context } from '@socfony/kernel';

declare module 'express' {
  export interface Request {
    context: Context;
  }
}
