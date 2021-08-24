import { Module } from '@nestjs/common';
import { EventEmitterModule } from '@nestjs/event-emitter';
import { PrismaModule } from '@socfony/prisma';
import { AppService } from './app.service';
import * as listeners from './listeners';
import { PrismaService } from './prisma.service';

@Module({
  imports: [
    EventEmitterModule.forRoot(),
  ],
  providers: [
    ...Object.values(listeners),
    AppService,
    PrismaService,
  ],
})
export class AppModule {}
