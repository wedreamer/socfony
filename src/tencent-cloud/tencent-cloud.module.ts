import { Module } from '@nestjs/common';
import { PrismaModule } from 'src/prisma';
import { TencentCloudService } from './tencent-cloud.service';

@Module({
  imports: [PrismaModule],
  providers: [TencentCloudService],
  exports: [TencentCloudService],
})
export class TencentCloudModule {}
