import { NestJS_Common } from '~deps';
import { ConfigModule } from '~config';
import { PrismaModule } from '~prisma';
import { TencentCloudShortMessageServiceModule } from '~sdk/tencent-cloud';
import { securityCodeSmsConfig } from './security-code.config';
import { SecurityCodeService } from './security-code.service';

/**
 * Sceurity code module.
 */
@NestJS_Common.Module({
  imports: [
    PrismaModule,
    TencentCloudShortMessageServiceModule,
    ConfigModule.forFeature(securityCodeSmsConfig),
  ],
  providers: [SecurityCodeService],
  exports: [SecurityCodeService],
})
export class SecurityCodeModule {}
