import {
  ClassProvider,
  Global,
  Inject,
  Injectable,
  Logger,
  Module,
  OnModuleDestroy,
  OnModuleInit,
} from '@nestjs/common';
import { Prisma, PrismaClient } from '@prisma/client';
import { databaseConfig } from 'src/config';
import { LoggerModule } from '../logger';
import { PrismaLoggerMiddleware } from './middleware';

/**
 * Prisma client NestJS service.
 */
@Injectable()
class PrismaService
  extends PrismaClient
  implements OnModuleInit, OnModuleDestroy {
  /**
   * Prisma client constructor
   * @param logger Logger
   */
  constructor(
    private readonly logger: Logger,
    @Inject(databaseConfig.KEY) database: Prisma.Datasource,
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
const provider: ClassProvider<PrismaClient> = {
  provide: PrismaClient,
  useClass: PrismaService,
};

/**
 * Prisma module.
 */
@Global()
@Module({
  imports: [LoggerModule],
  providers: [provider],
  exports: [provider],
})
export class PrismaModule {}
