import { Logger, Module } from '@nestjs/common';

/**
 * Logger module.
 */
@Module({
  providers: [Logger],
  exports: [Logger],
})
export class LoggerModule {}
