import { IsString, IsIn } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class RegisterPushTokenDto {
  @ApiProperty({ example: 'fcm-token-or-apns-token' })
  @IsString()
  token: string;

  @ApiProperty({ example: 'ios', enum: ['ios', 'android', 'web'] })
  @IsString()
  @IsIn(['ios', 'android', 'web'])
  platform: string;
}
