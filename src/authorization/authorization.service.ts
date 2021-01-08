import { Injectable } from "@nestjs/common";
import { AuthorizationToken, Prisma, PrismaClient, User } from "@prisma/client";
import { Request } from 'express';
import { AppExecutionContext } from "src/global";
import bcrypt from 'bcrypt';
import { nanoid } from "nanoid";
import dayjs from "dayjs";
import { USER_NOT_FOUND, USER_NOT_SET_PASSWORD, USER_PASSWORD_NOT_COMPARE } from "src/constants";

@Injectable()
export class AuthorizationService {
  constructor(private readonly prisma: PrismaClient) {}

  resolveHttpContext(request: Request): AppExecutionContext {
    if (!request) return {};
    const token = request.header('Authorization');
    const context = this.resolveContextForAuthorization(token);

    request.authorizationToken = context.authorizationToken;
    request.user = context.user;

    return context;
  }

  resolveContextForAuthorization(token: string) {
    if (!token) return {};
    return {
      authorizationToken: this.createAuthorizationTokenClient(this.prisma, token),
      user: this.createUserClient(this.prisma, token),
    };
  }

  createAuthorizationTokenClient(prisma: PrismaClient, token: string) {
    return (args?: Prisma.AuthorizationTokenArgs) => prisma.authorizationToken.findUnique(Object.assign({ where: { token }}, args));
  }

  createUserClient(prisma: PrismaClient, token: string) {
    return (args?: Prisma.UserArgs) => this.createAuthorizationTokenClient(prisma, token)().user(args);
  }

  createAuthorizationTokenForUser(user: User | string): Promise<AuthorizationToken> {
    return this.prisma.authorizationToken.create({
      data: {
        userId: typeof user === "string" ? user : user.id,
        token: nanoid(128),
        expiredAt: dayjs().add(1, "day").toDate(),
        refreshExpiredAt: dayjs().add(1, "day").toDate()
      }
    });
  }

  async loginWithPassword(where: Prisma.UserWhereUniqueInput, password: string) {
    const user = await this.prisma.user.findUnique({ where });
    if (!user || !user.password) {
      throw new Error(!user ? USER_NOT_FOUND : USER_NOT_SET_PASSWORD);
    }

    const hasMatch = await bcrypt.compare(password, user.password);
    if (hasMatch) {
      return await this.createAuthorizationTokenForUser(user);
    }

    throw new Error(USER_PASSWORD_NOT_COMPARE);
  }
}