import { Module } from '@nestjs/common';
import { Context } from './context';

@Module({
  providers: [Context],
  exports: [Context],
})
export class KernelModule {}
