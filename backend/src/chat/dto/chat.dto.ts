import { IsString, IsArray, IsOptional, IsBoolean } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class CreateConversationDto {
  @ApiProperty({ required: false })
  @IsOptional()
  @IsString()
  name?: string;

  @ApiProperty({ type: [String], example: ['user-id-1', 'user-id-2'] })
  @IsArray()
  @IsString({ each: true })
  participantIds: string[];
}

export class SendMessageDto {
  @ApiProperty({ example: 'Hello, how are you?' })
  @IsString()
  content: string;

  @ApiProperty({ required: false })
  @IsOptional()
  @IsBoolean()
  isEncrypted?: boolean;
}
