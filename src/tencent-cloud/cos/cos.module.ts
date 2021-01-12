import { Module } from '@nestjs/common';
import { PrismaModule } from 'src/prisma';
import { TencentCloudStsModule } from '../sts';
import { TencentCloudCosService } from './cos.service';

@Module({
  imports: [TencentCloudStsModule],
  providers: [TencentCloudCosService],
  exports: [TencentCloudCosService],
})
export class TencentCloudCosModule {}
