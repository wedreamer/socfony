import { ClassProvider, Injectable, Logger, Module } from '@nestjs/common';

/**
 * Logger service.
 */
@Injectable()
class LoggerService extends Logger {}

/**
 * Create logger provider
 */
const provider: ClassProvider<Logger> = {
  provide: Logger,
  useClass: LoggerService,
};

/**
 * Logger module.
 */
@Module({
  providers: [provider],
  exports: [provider],
})
export class LoggerModule {}
