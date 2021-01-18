import { NestJS } from '~deps';
import { Prisma, PrismaClient } from './client';
import { ConfigModule } from '../config';
import { LoggerModule } from '../logger';
import { databaseConfig } from './database.config';
import { PrismaLoggerMiddleware } from './middleware';

/**
 * Prisma client NestJS service.
 */
@NestJS.Common.Injectable()
class PrismaService
  extends PrismaClient
  implements NestJS.Common.OnModuleInit, NestJS.Common.OnModuleDestroy {
  /**
   * Prisma client constructor
   * @param logger Logger
   */
  constructor(
    private readonly logger: NestJS.Common.Logger,
    @NestJS.Common.Inject(databaseConfig.KEY) database: Prisma.Datasource,
  ) {
    super({
      datasources: { database },
    });
  }

  /**
   * NestJS module init hook callback.
   */
  async onModuleInit() {
    // Prisma connect database.
    await this.$connect();

    // Set Prisma client global logger middleware.
    this.$use(PrismaLoggerMiddleware(this.logger));

    // Write module init log.
    this.logger.log('Database connected', 'Prisma');
  }

  /**
   * NestJS module destory hook callback.
   */
  async onModuleDestroy() {
    // Prisma disconnect database.
    await this.$disconnect();

    // Write module destory log.
    this.logger.log('Database disconnected', 'Prisma');
  }
}

/**
 * Create Prisma client provider.
 */
const provider: NestJS.Common.ClassProvider<PrismaClient> = {
  provide: PrismaClient,
  useClass: PrismaService,
};

/**
 * Prisma module.
 */
@NestJS.Common.Module({
  imports: [LoggerModule, ConfigModule.forFeature(databaseConfig)],
  providers: [provider],
  exports: [provider],
})
export class PrismaModule {}
