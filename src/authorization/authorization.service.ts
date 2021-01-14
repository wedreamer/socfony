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
  AUTHORIZATION_TOKEN_NOT_FOUND,
  SECURITY_VALIDATE_ERROR,
  USER_NOT_FOUND,
  USER_NOT_SET_PASSWORD,
  USER_PASSWORD_NOT_COMPARE,
} from 'src/constants';
import { AuthorizationTokenValidityPeriod } from './types';
import { SecurityCodeService } from 'src/security-code/security-code.service';
import { nanoIdGenerator } from 'src/helper';

/**
 * Authoprization service.
 */
@Injectable()
export class AuthorizationService {
  constructor(
    private readonly prisma: PrismaClient,
    private readonly securityService: SecurityCodeService,
  ) {}

  /**
   * Get token expired in validity period.
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

  /**
   * Resolve Http context.
   * @param request `Express`.`Request` instance.
   */
  resolveHttpContext(request: Request): AppExecutionContext {
    if (!request) return { request };
    const token = request.header('Authorization');
    const context = this.resolveContextForAuthorization(token);

    request.authorizationTokenClient = context.authorizationTokenClient;
    request.userClient = context.userClient;
    request.request = request;

    return { ...context, request };
  }

  /**
   * Resolve Application context for token.
   * @param token HTTP endpoint `Authorization` token.
   */
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

  /**
   * Create `AuthorizationToken` object Prisma query client.
   * @param prisma Prisma client.
   * @param token HTTP endpoint `Authorization` token.
   */
  createAuthorizationTokenClient(prisma: PrismaClient, token: string) {
    return (args?: Prisma.AuthorizationTokenArgs) =>
      prisma.authorizationToken.findUnique(
        Object.assign({ where: { token } }, args),
      );
  }

  /**
   * Create `User` object Prisma query client for token.
   * @param prisma Prisma client.
   * @param token HTTP endpoint `Authorization` token.
   */
  createUserClient(prisma: PrismaClient, token: string) {
    return (args?: Prisma.UserArgs) =>
      this.createAuthorizationTokenClient(prisma, token)().user(args);
  }

  /**
   * Create authorization token object for user.
   * @param user Create authoprization token object user.
   */
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

  /**
   * Refresh authorization token object to database.
   * @param authorizationToken Await refresh authorization token object.
   */
  async refreshAuthorizationToken(
    authorizationToken:
      | AuthorizationToken
      | string
      | Promise<AuthorizationToken>,
  ): Promise<AuthorizationToken> {
    const setting = await this.getTokenExpiredIn();
    const authorization = await this.resolveAuthorizationToken(
      authorizationToken,
    );
    // If authorization token not found, throw `not found` error.
    if (!authorization) {
      throw new Error(AUTHORIZATION_TOKEN_NOT_FOUND);

      // If token is expired, update to new token.
    } else if (authorization.expiredAt.getTime() <= Date.now()) {
      return await this.prisma.authorizationToken.update({
        where: { token: authorization.token },
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

    // If the token validity period is greater than 5 minutes,
    // set it to expire in three minutes, and then create a new token
    const fiveMinutesDate = dayjs().add(5, 'minutes').toDate();
    if (authorization.expiredAt.getTime() > fiveMinutesDate.getTime()) {
      const [value] = await this.prisma.$transaction([
        this.createAuthorizationTokenForUser(authorization.userId),
        this.prisma.authorizationToken.update({
          where: { token: authorization.token },
          data: {
            expiredAt: fiveMinutesDate,
            refreshExpiredAt: new Date(),
          },
        }),
      ]);
      return value;
    }

    return this.createAuthorizationTokenForUser(authorization.userId);
  }

  /**
   * resolve authorization token
   * @param authorizationToken Await refresh authorization token object.
   */
  async resolveAuthorizationToken(
    authorizationToken:
      | AuthorizationToken
      | string
      | Promise<AuthorizationToken>,
  ): Promise<AuthorizationToken> {
    if (typeof authorizationToken === 'string') {
      return this.prisma.authorizationToken.findUnique({
        where: { token: authorizationToken },
      });
    }

    return await authorizationToken;
  }

  /**
   * Using user password login and create authorization token object.
   * @param where User query where input.
   * @param password User password string.
   */
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

  /**
   * Using security code login and create authorization token object.
   * @param where User query where input.
   * @param code User login security code.
   */
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

  /**
   * Has authorization token expired.
   * @param client `AuthotizationToken` query Prisma client.
   * @param type Validate type.
   */
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
