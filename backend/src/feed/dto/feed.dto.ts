import { IsString, IsOptional, IsUrl, IsIn } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class CreatePostDto {
  @ApiProperty({ example: 'This is my first post!' })
  @IsString()
  content: string;

  @ApiProperty({ required: false })
  @IsOptional()
  @IsUrl()
  imageUrl?: string;
}

export class CreateCommentDto {
  @ApiProperty({ example: 'Great post!' })
  @IsString()
  content: string;
}

export class CreateReactionDto {
  @ApiProperty({ example: 'like', enum: ['like', 'love', 'haha', 'wow', 'sad', 'angry'] })
  @IsString()
  @IsIn(['like', 'love', 'haha', 'wow', 'sad', 'angry'])
  type: string;
}
