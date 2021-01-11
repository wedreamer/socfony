import { forwardRef, Module } from '@nestjs/common';
import { PrismaModule } from 'src/prisma';
import { TencentCloudShortMessageServiceModule } from './sms';
import { TencentCloudService } from './tencent-cloud.service';

@Module({
  imports: [
    PrismaModule,
    forwardRef(() => TencentCloudShortMessageServiceModule),
  ],
  providers: [TencentCloudService],
  exports: [TencentCloudShortMessageServiceModule, TencentCloudService],
})
export class TencentCloudModule {}
