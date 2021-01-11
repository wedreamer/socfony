import { Injectable } from '@nestjs/common';
import { AuthorizationToken, Prisma, PrismaClient, User } from '@prisma/client';
import { Request } from 'express';
import {
  AppExecutionContext,
  AuthorizationTokenPrismaClient,
} from 'src/global';
import bcrypt from 'bcrypt';
import dayjs = require('dayjs');
import {
  SECURITY_VALIDATE_ERROR,
  USER_NOT_FOUND,
  USER_NOT_SET_PASSWORD,
  USER_PASSWORD_NOT_COMPARE,
} from 'src/constants';
import { AuthorizationTokenValidityPeriod } from './types';
import { SecurityCodeService } from 'src/security-code/security-code.service';
import { nanoIdGenerator } from 'src/helper';

@Injectable()
export class AuthorizationService {
  constructor(
    private readonly prisma: PrismaClient,
    private readonly securityService: SecurityCodeService,
  ) {}

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

    request.authorizationTokenClient = context.authorizationTokenClient;
    request.userClient = context.userClient;
    request.request = request;

    return { ...context, request };
  }

  resolveContextForAuthorization(
    token: string,
  ): Pick<AppExecutionContext, 'authorizationTokenClient' | 'userClient'> {
    if (!token) return {};
    return {
      authorizationTokenClient: this.createAuthorizationTokenClient(
        this.prisma,
        token,
      ),
      userClient: this.createUserClient(this.prisma, token),
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
        token: nanoIdGenerator(128),
        expiredAt: dayjs()
          .add(setting.expiredIn.value, setting.expiredIn.unit)
          .toDate(),
        refreshExpiredAt: dayjs()
          .add(setting.refreshExpiredIn.value, setting.refreshExpiredIn.unit)
          .toDate(),
      },
    });
  }

  async refreshAuthorizationToken(
    authorizationToken:
      | AuthorizationToken
      | string
      | Promise<AuthorizationToken>,
  ): Promise<AuthorizationToken> {
    const authorization = await authorizationToken;
    const setting = await this.getTokenExpiredIn();
    return this.prisma.authorizationToken.update({
      where: {
        token:
          typeof authorization === 'string'
            ? authorization
            : authorization.token,
      },
      data: {
        token: nanoIdGenerator(128),
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

  async loginWithSecurityCode(
    where: Prisma.UserWhereUniqueInput,
    code: string,
  ) {
    const account = Object.values(where).pop();
    const security = await this.securityService.findFirst(account, code);
    if (await this.securityService.validateSecurity(security)) {
      throw new Error(SECURITY_VALIDATE_ERROR);
    }
    let user = await this.prisma.user.findUnique({ where });
    if (!user) {
      const { email, phone } = where;
      user = await this.prisma.user.create({
        data: {
          email,
          phone,
          id: nanoIdGenerator(32),
        },
      });
    }
    this.securityService.disableSecurity(security);

    return this.createAuthorizationTokenForUser(user);
  }

  async hasTokenExpired(
    client: AuthorizationTokenPrismaClient | AuthorizationToken,
    type: 'auth' | 'refresh',
  ): Promise<boolean> {
    const token = typeof client === 'function' ? await client() : client;
    if (!token) return true;
    const expiredAt =
      type === 'auth' ? token.expiredAt : token.refreshExpiredAt;

    return expiredAt.getTime() <= Date.now();
  }
}
