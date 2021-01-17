import { NestJS_Common } from '~deps';
import { AuthorizationToken, PrismaClient, User } from '~prisma';
import { AppContext } from './app.context';
import { Request } from './express';

@NestJS_Common.Injectable()
export class AppContextService {
  private context: AppContext;

  constructor(private readonly prisma: PrismaClient) {
    this.context = new AppContext();
  }

  getContext(): AppContext {
    return this.context;
  }

  async createContext(request: Request): Promise<AppContext> {
    this.context = new AppContext();
    this.context.request = request;
    this.context.authorizationToken = await this.getAuthorizationToken(
      this.getHttpAuthorization(request),
    );
    this.context.user = await this.getAuthorizationUser(
      this.context.authorizationToken,
    );

    return this.context;
  }

  getHttpAuthorization(request: Request): string {
    if (request) return request.header('Authorization');
  }

  resolve(context: NestJS_Common.ExecutionContext): AppContext {
    return AppContext.resolve(context);
  }

  private getAuthorizationToken(token: string): Promise<AuthorizationToken> {
    if (token)
      return this.prisma.authorizationToken.findUnique({
        where: { token: token },
      });
  }

  private getAuthorizationUser(
    authorizationToken: AuthorizationToken,
  ): Promise<User> {
    if (authorizationToken && authorizationToken.userId)
      return this.prisma.user.findUnique({
        where: { id: authorizationToken.userId },
      });
  }
}
