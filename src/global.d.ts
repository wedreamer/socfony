import { AuthorizationToken, Prisma, User } from '@prisma/client';
import { Request } from 'express';

/**
 * HTTP endpoint `Authorization` Prisma query client.
 */
export type AuthorizationTokenPrismaClient<
  T extends Prisma.AuthorizationTokenArgs = Prisma.AuthorizationTokenArgs
> = (
  args?: T,
) => Prisma.CheckSelect<
  T,
  Prisma.Prisma__AuthorizationTokenClient<AuthorizationToken | null>,
  Prisma.Prisma__AuthorizationTokenClient<Prisma.AuthorizationTokenGetPayload<T> | null>
>;

/**
 * HTTP endpoint `Authorization` bound user Prisma query client.
 */
export type UserPrismaClient<T extends Prisma.UserArgs = Prisma.UserArgs> = (
  args?: T,
) => Prisma.CheckSelect<
  T,
  Prisma.Prisma__UserClient<User | null>,
  Prisma.Prisma__UserClient<Prisma.UserGetPayload<T> | null>
>;

/**
 * Application context
 */
export class AppExecutionContext {
  /**
   * Authenticated user token
   */
  authorizationTokenClient?: AuthorizationTokenPrismaClient;

  /**
   * Authenticated user
   */
  userClient?: UserPrismaClient;

  /**
   * Has user logged
   */
  hasLogged?: boolean;

  /**
   * Express request
   */
  request: Request;
}

/**
 * declar global.
 */
declare global {
  // declar `Express` namespace.
  namespace Express {
    // merged `Express.Request`.
    interface Request extends AppExecutionContext {}
  }
}
