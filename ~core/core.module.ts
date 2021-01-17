import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { PrismaModule } from '~prisma';
import { AppContextService } from './app-context.service';
import { coreConfig } from './core.config';

const config = ConfigModule.forFeature(coreConfig);

@Module({
  imports: [PrismaModule, config],
  providers: [AppContextService],
  exports: [AppContextService, config],
})
export class CoreModule {}
