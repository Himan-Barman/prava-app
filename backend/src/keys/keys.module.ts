import { Module } from '@nestjs/common';
import { KeysController } from './keys.controller';
import { KeysService } from './keys.service';
import { PrismaService } from '../prisma.service';

@Module({
  controllers: [KeysController],
  providers: [KeysService, PrismaService],
})
export class KeysModule {}
