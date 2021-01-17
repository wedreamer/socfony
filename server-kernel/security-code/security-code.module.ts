import { NestJS } from '~deps';
import { ConfigModule } from 'server-kernel/config';
import { PrismaModule } from 'server-kernel/prisma';
import { TencentCloudShortMessageServiceModule } from 'server-kernel/sdk/tencent-cloud';
import { securityCodeSmsConfig } from './security-code.config';
import { SecurityCodeService } from './security-code.service';

/**
 * Sceurity code module.
 */
@NestJS.Common.Module({
  imports: [
    PrismaModule,
    TencentCloudShortMessageServiceModule,
    ConfigModule.forFeature(securityCodeSmsConfig),
  ],
  providers: [SecurityCodeService],
  exports: [SecurityCodeService],
})
export class SecurityCodeModule {}
