import { AuthorizationToken, Prisma, User } from '@prisma/client';
import { Request } from 'express';

export type AuthorizationTokenPrismaClient<
  T = Prisma.AuthorizationTokenArgs
> = (
  args?: T,
) => Prisma.CheckSelect<
  T,
  Prisma.Prisma__AuthorizationTokenClient<AuthorizationToken | null>,
  Prisma.Prisma__AuthorizationTokenClient<Prisma.AuthorizationTokenGetPayload<T> | null>
>;

export type UserPrismaClient<T = Prisma.UserArgs> = (
  args?: T,
) => Prisma.CheckSelect<
  T,
  Prisma.Prisma__UserClient<User | null>,
  Prisma.Prisma__UserClient<Prisma.UserGetPayload<T> | null>
>;

export interface AppExecutionContext {
  /**
   * Authenticated user token
   */
  authorizationToken?: AuthorizationTokenPrismaClient;

  /**
   * Authenticated user
   */
  user?: UserPrismaClient;

  /**
   * Has user logged
   */
  hasLogged?: boolean;

  /**
   * Express request
   */
  request: Request;
}

declare global {
  namespace Express {
    interface Request extends AppExecutionContext {}
  }
}
