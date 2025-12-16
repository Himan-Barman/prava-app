import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { ThrottlerModule } from '@nestjs/throttler';
import { AuthModule } from './auth/auth.module';
import { UsersModule } from './users/users.module';
import { FeedModule } from './feed/feed.module';
import { ChatModule } from './chat/chat.module';
import { NotificationsModule } from './notifications/notifications.module';
import { KeysModule } from './keys/keys.module';
import { PrismaService } from './prisma.service';
import { RedisService } from './redis.service';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
    }),
    ThrottlerModule.forRoot([
      {
        ttl: parseInt(process.env.THROTTLE_TTL || '60', 10) * 1000,
        limit: parseInt(process.env.THROTTLE_LIMIT || '10', 10),
      },
    ]),
    AuthModule,
    UsersModule,
    FeedModule,
    ChatModule,
    NotificationsModule,
    KeysModule,
  ],
  providers: [PrismaService, RedisService],
  exports: [PrismaService, RedisService],
})
export class AppModule {}
