import { Injectable, NotFoundException, ForbiddenException } from '@nestjs/common';
import { PrismaService } from '../prisma.service';
import { CreateConversationDto, SendMessageDto } from './dto/chat.dto';

@Injectable()
export class ChatService {
  constructor(private prisma: PrismaService) {}

  async createConversation(userId: string, dto: CreateConversationDto) {
    const conversation = await this.prisma.conversation.create({
      data: {
        name: dto.name,
        isGroup: dto.participantIds.length > 1,
        participants: {
          create: [{ userId }, ...dto.participantIds.map((id) => ({ userId: id }))],
        },
      },
      include: {
        participants: {
          include: {
            user: {
              select: {
                id: true,
                username: true,
                displayName: true,
                avatarUrl: true,
              },
            },
          },
        },
      },
    });

    return conversation;
  }

  async getConversations(userId: string) {
    const conversations = await this.prisma.conversation.findMany({
      where: {
        participants: {
          some: { userId },
        },
      },
      include: {
        participants: {
          include: {
            user: {
              select: {
                id: true,
                username: true,
                displayName: true,
                avatarUrl: true,
              },
            },
          },
        },
        messages: {
          orderBy: { createdAt: 'desc' },
          take: 1,
        },
      },
      orderBy: { updatedAt: 'desc' },
    });

    return conversations;
  }

  async getConversation(userId: string, conversationId: string) {
    const conversation = await this.prisma.conversation.findFirst({
      where: {
        id: conversationId,
        participants: {
          some: { userId },
        },
      },
      include: {
        participants: {
          include: {
            user: {
              select: {
                id: true,
                username: true,
                displayName: true,
                avatarUrl: true,
              },
            },
          },
        },
      },
    });

    if (!conversation) {
      throw new NotFoundException('Conversation not found');
    }

    return conversation;
  }

  async getMessages(userId: string, conversationId: string, page = 1, limit = 50) {
    // Verify user is participant
    await this.getConversation(userId, conversationId);

    const skip = (page - 1) * limit;

    const messages = await this.prisma.message.findMany({
      where: { conversationId },
      skip,
      take: limit,
      orderBy: { createdAt: 'desc' },
      include: {
        sender: {
          select: {
            id: true,
            username: true,
            displayName: true,
            avatarUrl: true,
          },
        },
      },
    });

    return messages.reverse();
  }

  async sendMessage(userId: string, conversationId: string, dto: SendMessageDto) {
    // Verify user is participant
    await this.getConversation(userId, conversationId);

    const message = await this.prisma.message.create({
      data: {
        content: dto.content,
        conversationId,
        senderId: userId,
        isEncrypted: dto.isEncrypted || false,
      },
      include: {
        sender: {
          select: {
            id: true,
            username: true,
            displayName: true,
            avatarUrl: true,
          },
        },
      },
    });

    // Update conversation timestamp
    await this.prisma.conversation.update({
      where: { id: conversationId },
      data: { updatedAt: new Date() },
    });

    return message;
  }

  async markAsRead(userId: string, conversationId: string) {
    // Verify user is participant
    const conversation = await this.getConversation(userId, conversationId);

    const participant = conversation.participants.find((p) => p.userId === userId);

    if (!participant) {
      throw new ForbiddenException('Not a participant');
    }

    await this.prisma.conversationParticipant.update({
      where: { id: participant.id },
      data: { lastReadAt: new Date() },
    });

    return { message: 'Marked as read' };
  }

  async deleteConversation(userId: string, conversationId: string) {
    const conversation = await this.getConversation(userId, conversationId);

    // Only allow deletion if user is creator (first participant) or it's a direct conversation
    if (conversation.isGroup) {
      throw new ForbiddenException('Cannot delete group conversations');
    }

    await this.prisma.conversation.delete({
      where: { id: conversationId },
    });

    return { message: 'Conversation deleted' };
  }
}
