import { Injectable } from '@nestjs/common';
import { AuthorizationToken, Prisma, PrismaClient, User } from '@prisma/client';
import { Request } from 'express';
import {
  AppExecutionContext,
  AuthorizationTokenPrismaClient,
} from 'src/global';
import bcrypt from 'bcrypt';
import { nanoid } from 'nanoid';
import dayjs from 'dayjs';
import {
  USER_NOT_FOUND,
  USER_NOT_SET_PASSWORD,
  USER_PASSWORD_NOT_COMPARE,
} from 'src/constants';
import { AuthorizationTokenValidityPeriod } from './types';

@Injectable()
export class AuthorizationService {
  constructor(private readonly prisma: PrismaClient) {}

  /**
   * Get token expored in validity period.
   */
  async getTokenExpiredIn(): Promise<AuthorizationTokenValidityPeriod> {
    const setting = await this.prisma.setting.findUnique({
      where: {
        namespace_name: {
          namespace: 'system',
          name: 'authorization-token-validity-period',
        },
      },
    });
    const { value = {} } = setting || {};
    const { expiredIn = {}, refreshExpiredIn = {} } = value as any;

    return {
      expiredIn: {
        value: expiredIn.value || 1,
        unit: expiredIn.unit || 'day',
      },
      refreshExpiredIn: {
        value: refreshExpiredIn.value || 7,
        unit: refreshExpiredIn.unit || 'day',
      },
    };
  }

  resolveHttpContext(request: Request): AppExecutionContext {
    if (!request) return { request };
    const token = request.header('Authorization');
    const context = this.resolveContextForAuthorization(token);

    request.authorizationToken = context.authorizationToken;
    request.user = context.user;
    request.request = request;

    return { ...context, request };
  }

  resolveContextForAuthorization(
    token: string,
  ): Pick<AppExecutionContext, 'authorizationToken' | 'user'> {
    if (!token) return {};
    return {
      authorizationToken: this.createAuthorizationTokenClient(
        this.prisma,
        token,
      ),
      user: this.createUserClient(this.prisma, token),
    };
  }

  createAuthorizationTokenClient(prisma: PrismaClient, token: string) {
    return (args?: Prisma.AuthorizationTokenArgs) =>
      prisma.authorizationToken.findUnique(
        Object.assign({ where: { token } }, args),
      );
  }

  createUserClient(prisma: PrismaClient, token: string) {
    return (args?: Prisma.UserArgs) =>
      this.createAuthorizationTokenClient(prisma, token)().user(args);
  }

  async createAuthorizationTokenForUser(
    user: User | string,
  ): Promise<AuthorizationToken> {
    const setting = await this.getTokenExpiredIn();
    return await this.prisma.authorizationToken.create({
      data: {
        userId: typeof user === 'string' ? user : user.id,
        token: nanoid(128),
        expiredAt: dayjs()
          .add(setting.expiredIn.value, setting.expiredIn.unit)
          .toDate(),
        refreshExpiredAt: dayjs()
          .add(setting.refreshExpiredIn.value, setting.refreshExpiredIn.unit)
          .toDate(),
      },
    });
  }

  async loginWithPassword(
    where: Prisma.UserWhereUniqueInput,
    password: string,
  ) {
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

  async hasTokenExpired(
    client: AuthorizationTokenPrismaClient | AuthorizationToken,
    type: 'auth' | 'refresh',
  ): Promise<boolean> {
    const token = typeof client === 'function' ? await client() : client;
    if (!token) return false;
    const expiredAt =
      type === 'auth' ? token.expiredAt : token.refreshExpiredAt;

    return expiredAt.getTime() <= Date.now();
  }
}
