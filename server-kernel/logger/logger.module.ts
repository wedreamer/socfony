import { NestJS } from '~deps';
import { Logger } from './logger';

/**
 * Logger module.
 */
@NestJS.Common.Module({
  providers: [Logger],
  exports: [Logger],
})
export class LoggerModule {}
