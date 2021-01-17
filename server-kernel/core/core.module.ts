import { NestJS } from '~deps';
import { PrismaModule } from 'server-kernel/prisma';
import { AppContextService } from './app-context.service';
import { coreConfig } from './core.config';

const config = NestJS.Config.ConfigModule.forFeature(coreConfig);

@NestJS.Common.Module({
  imports: [PrismaModule, config],
  providers: [AppContextService],
  exports: [AppContextService, config],
})
export class CoreModule {}
