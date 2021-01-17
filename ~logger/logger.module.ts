import { NestJS_Common } from '~deps';
import { Logger } from './logger';

/**
 * Logger module.
 */
@NestJS_Common.Module({
  providers: [Logger],
  exports: [Logger],
})
export class LoggerModule {}
