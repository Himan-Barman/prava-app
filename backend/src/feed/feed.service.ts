import { Injectable, NotFoundException, ForbiddenException } from '@nestjs/common';
import { PrismaService } from '../prisma.service';
import { CreatePostDto, CreateCommentDto, CreateReactionDto } from './dto/feed.dto';

@Injectable()
export class FeedService {
  constructor(private prisma: PrismaService) {}

  async createPost(userId: string, dto: CreatePostDto) {
    const post = await this.prisma.post.create({
      data: {
        content: dto.content,
        imageUrl: dto.imageUrl,
        authorId: userId,
      },
      include: {
        author: {
          select: {
            id: true,
            username: true,
            displayName: true,
            avatarUrl: true,
          },
        },
      },
    });

    return post;
  }

  async getFeed(page = 1, limit = 20) {
    const skip = (page - 1) * limit;

    const posts = await this.prisma.post.findMany({
      skip,
      take: limit,
      orderBy: { createdAt: 'desc' },
      include: {
        author: {
          select: {
            id: true,
            username: true,
            displayName: true,
            avatarUrl: true,
          },
        },
        _count: {
          select: {
            comments: true,
            reactions: true,
          },
        },
      },
    });

    return posts;
  }

  async getPost(postId: string) {
    const post = await this.prisma.post.findUnique({
      where: { id: postId },
      include: {
        author: {
          select: {
            id: true,
            username: true,
            displayName: true,
            avatarUrl: true,
          },
        },
        comments: {
          include: {
            author: {
              select: {
                id: true,
                username: true,
                displayName: true,
                avatarUrl: true,
              },
            },
          },
          orderBy: { createdAt: 'desc' },
        },
        reactions: {
          include: {
            user: {
              select: {
                id: true,
                username: true,
              },
            },
          },
        },
      },
    });

    if (!post) {
      throw new NotFoundException('Post not found');
    }

    return post;
  }

  async deletePost(userId: string, postId: string) {
    const post = await this.prisma.post.findUnique({
      where: { id: postId },
    });

    if (!post) {
      throw new NotFoundException('Post not found');
    }

    if (post.authorId !== userId) {
      throw new ForbiddenException('You can only delete your own posts');
    }

    await this.prisma.post.delete({
      where: { id: postId },
    });

    return { message: 'Post deleted successfully' };
  }

  async createComment(userId: string, postId: string, dto: CreateCommentDto) {
    const post = await this.prisma.post.findUnique({
      where: { id: postId },
    });

    if (!post) {
      throw new NotFoundException('Post not found');
    }

    const comment = await this.prisma.comment.create({
      data: {
        content: dto.content,
        postId,
        authorId: userId,
      },
      include: {
        author: {
          select: {
            id: true,
            username: true,
            displayName: true,
            avatarUrl: true,
          },
        },
      },
    });

    return comment;
  }

  async createReaction(userId: string, postId: string, dto: CreateReactionDto) {
    const post = await this.prisma.post.findUnique({
      where: { id: postId },
    });

    if (!post) {
      throw new NotFoundException('Post not found');
    }

    // Check if user already reacted
    const existingReaction = await this.prisma.reaction.findUnique({
      where: {
        postId_userId_type: {
          postId,
          userId,
          type: dto.type,
        },
      },
    });

    if (existingReaction) {
      // Remove reaction (toggle)
      await this.prisma.reaction.delete({
        where: { id: existingReaction.id },
      });
      return { message: 'Reaction removed' };
    }

    const reaction = await this.prisma.reaction.create({
      data: {
        type: dto.type,
        postId,
        userId,
      },
    });

    return reaction;
  }
}
