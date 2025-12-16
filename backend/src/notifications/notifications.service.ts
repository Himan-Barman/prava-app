import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma.service';
import { RegisterPushTokenDto } from './dto/notification.dto';

@Injectable()
export class NotificationsService {
  constructor(private prisma: PrismaService) {}

  async registerPushToken(userId: string, dto: RegisterPushTokenDto) {
    // Check if token already exists
    const existingToken = await this.prisma.pushToken.findUnique({
      where: { token: dto.token },
    });

    if (existingToken) {
      // Update the user if needed
      if (existingToken.userId !== userId) {
        await this.prisma.pushToken.update({
          where: { token: dto.token },
          data: { userId, platform: dto.platform },
        });
      }
      return existingToken;
    }

    const pushToken = await this.prisma.pushToken.create({
      data: {
        userId,
        token: dto.token,
        platform: dto.platform,
      },
    });

    return pushToken;
  }

  async getNotifications(userId: string, page = 1, limit = 20) {
    const skip = (page - 1) * limit;

    const notifications = await this.prisma.notification.findMany({
      where: { userId },
      skip,
      take: limit,
      orderBy: { createdAt: 'desc' },
    });

    return notifications;
  }

  async markAsRead(userId: string, notificationId: string) {
    await this.prisma.notification.updateMany({
      where: {
        id: notificationId,
        userId,
      },
      data: { isRead: true },
    });

    return { message: 'Notification marked as read' };
  }

  async markAllAsRead(userId: string) {
    await this.prisma.notification.updateMany({
      where: { userId, isRead: false },
      data: { isRead: true },
    });

    return { message: 'All notifications marked as read' };
  }

  async createNotification(userId: string, type: string, title: string, body: string, data?: any) {
    const notification = await this.prisma.notification.create({
      data: {
        userId,
        type,
        title,
        body,
        data,
      },
    });

    // TODO: Send push notification to user's devices
    // TODO: Replace with proper logging service
    console.log(`Notification created: ${notification.id}`);

    return notification;
  }
}
