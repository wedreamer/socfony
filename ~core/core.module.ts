import { NestJS_Common, NestJS_Config } from '~deps';
import { PrismaModule } from '~prisma';
import { AppContextService } from './app-context.service';
import { coreConfig } from './core.config';

const config = NestJS_Config.ConfigModule.forFeature(coreConfig);

@NestJS_Common.Module({
  imports: [PrismaModule, config],
  providers: [AppContextService],
  exports: [AppContextService, config],
})
export class CoreModule {}
