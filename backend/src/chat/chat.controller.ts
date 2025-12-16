import { Controller, Get, Post, Delete, Body, Param, Query, UseGuards } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth } from '@nestjs/swagger';
import { ChatService } from './chat.service';
import { CreateConversationDto, SendMessageDto } from './dto/chat.dto';
import { JwtAuthGuard } from '../common/guards/jwt-auth.guard';
import { CurrentUser } from '../common/decorators/current-user.decorator';

@ApiTags('chat')
@Controller('chat')
@UseGuards(JwtAuthGuard)
@ApiBearerAuth()
export class ChatController {
  constructor(private chatService: ChatService) {}

  @Post('conversations')
  @ApiOperation({ summary: 'Create a new conversation' })
  async createConversation(@CurrentUser() user: any, @Body() dto: CreateConversationDto) {
    return this.chatService.createConversation(user.id, dto);
  }

  @Get('conversations')
  @ApiOperation({ summary: 'Get user conversations' })
  async getConversations(@CurrentUser() user: any) {
    return this.chatService.getConversations(user.id);
  }

  @Get('conversations/:conversationId')
  @ApiOperation({ summary: 'Get conversation details' })
  async getConversation(@CurrentUser() user: any, @Param('conversationId') conversationId: string) {
    return this.chatService.getConversation(user.id, conversationId);
  }

  @Get('conversations/:conversationId/messages')
  @ApiOperation({ summary: 'Get conversation messages' })
  async getMessages(
    @CurrentUser() user: any,
    @Param('conversationId') conversationId: string,
    @Query('page') page?: number,
    @Query('limit') limit?: number,
  ) {
    return this.chatService.getMessages(user.id, conversationId, page, limit);
  }

  @Post('conversations/:conversationId/messages')
  @ApiOperation({ summary: 'Send a message' })
  async sendMessage(
    @CurrentUser() user: any,
    @Param('conversationId') conversationId: string,
    @Body() dto: SendMessageDto,
  ) {
    return this.chatService.sendMessage(user.id, conversationId, dto);
  }

  @Post('conversations/:conversationId/read')
  @ApiOperation({ summary: 'Mark conversation as read' })
  async markAsRead(@CurrentUser() user: any, @Param('conversationId') conversationId: string) {
    return this.chatService.markAsRead(user.id, conversationId);
  }

  @Delete('conversations/:conversationId')
  @ApiOperation({ summary: 'Delete conversation' })
  async deleteConversation(
    @CurrentUser() user: any,
    @Param('conversationId') conversationId: string,
  ) {
    return this.chatService.deleteConversation(user.id, conversationId);
  }
}
