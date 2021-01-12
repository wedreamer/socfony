import { Module } from '@nestjs/common';
import { PrismaModule } from 'src/prisma';
import { TencentCloudStsModule } from '../sts';
import { TencentCloudModule } from '../tencent-cloud.module';
import { TencentCloudCosService } from './cos.service';

@Module({
  imports: [TencentCloudStsModule, TencentCloudModule, PrismaModule],
  providers: [TencentCloudCosService],
  exports: [TencentCloudCosService],
})
export class TencentCloudCosModule {}
