import { AuthorizationToken, Prisma, User } from '@prisma/client';

type AuthorizationTokenPrismaClient<T = Prisma.AuthorizationTokenArgs> = (
  args: T,
) => Prisma.CheckSelect<
  T,
  Prisma.Prisma__AuthorizationTokenClient<AuthorizationToken | null>,
  Prisma.Prisma__AuthorizationTokenClient<Prisma.AuthorizationTokenGetPayload<T> | null>
>;

type UserPrismaClient<T = Prisma.UserArgs> = (
  args: T,
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
}

declare global {
  namespace Express {
    interface Request extends AppExecutionContext {}
  }
}
