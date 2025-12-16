import { Controller, Get, Post, Delete, Body, Param, Query, UseGuards } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth } from '@nestjs/swagger';
import { FeedService } from './feed.service';
import { CreatePostDto, CreateCommentDto, CreateReactionDto } from './dto/feed.dto';
import { JwtAuthGuard } from '../common/guards/jwt-auth.guard';
import { CurrentUser } from '../common/decorators/current-user.decorator';

@ApiTags('feed')
@Controller('feed')
@UseGuards(JwtAuthGuard)
@ApiBearerAuth()
export class FeedController {
  constructor(private feedService: FeedService) {}

  @Post('posts')
  @ApiOperation({ summary: 'Create a new post' })
  async createPost(@CurrentUser() user: any, @Body() dto: CreatePostDto) {
    return this.feedService.createPost(user.id, dto);
  }

  @Get('posts')
  @ApiOperation({ summary: 'Get feed posts' })
  async getFeed(@Query('page') page?: number, @Query('limit') limit?: number) {
    return this.feedService.getFeed(page, limit);
  }

  @Get('posts/:postId')
  @ApiOperation({ summary: 'Get post by ID' })
  async getPost(@Param('postId') postId: string) {
    return this.feedService.getPost(postId);
  }

  @Delete('posts/:postId')
  @ApiOperation({ summary: 'Delete a post' })
  async deletePost(@CurrentUser() user: any, @Param('postId') postId: string) {
    return this.feedService.deletePost(user.id, postId);
  }

  @Post('posts/:postId/comments')
  @ApiOperation({ summary: 'Add a comment to a post' })
  async createComment(
    @CurrentUser() user: any,
    @Param('postId') postId: string,
    @Body() dto: CreateCommentDto,
  ) {
    return this.feedService.createComment(user.id, postId, dto);
  }

  @Post('posts/:postId/reactions')
  @ApiOperation({ summary: 'Add or remove a reaction to a post' })
  async createReaction(
    @CurrentUser() user: any,
    @Param('postId') postId: string,
    @Body() dto: CreateReactionDto,
  ) {
    return this.feedService.createReaction(user.id, postId, dto);
  }
}
