import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma.service';
import { RegisterE2EEKeyDto } from './dto/keys.dto';

@Injectable()
export class KeysService {
  constructor(private prisma: PrismaService) {}

  async registerKey(userId: string, dto: RegisterE2EEKeyDto) {
    // Check if key already exists for this device
    const existingKey = await this.prisma.e2EEKey.findUnique({
      where: {
        userId_deviceId: {
          userId,
          deviceId: dto.deviceId,
        },
      },
    });

    if (existingKey) {
      // Update the key
      return this.prisma.e2EEKey.update({
        where: { id: existingKey.id },
        data: { publicKey: dto.publicKey },
      });
    }

    // Create new key
    const key = await this.prisma.e2EEKey.create({
      data: {
        userId,
        publicKey: dto.publicKey,
        deviceId: dto.deviceId,
      },
    });

    return key;
  }

  async getKeys(userId: string) {
    const keys = await this.prisma.e2EEKey.findMany({
      where: { userId },
    });

    return keys;
  }

  async getUserKeys(targetUserId: string) {
    const keys = await this.prisma.e2EEKey.findMany({
      where: { userId: targetUserId },
      select: {
        id: true,
        publicKey: true,
        deviceId: true,
        createdAt: true,
      },
    });

    return keys;
  }

  async deleteKey(userId: string, deviceId: string) {
    await this.prisma.e2EEKey.deleteMany({
      where: {
        userId,
        deviceId,
      },
    });

    return { message: 'Key deleted successfully' };
  }
}
