import { IsString } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class RegisterE2EEKeyDto {
  @ApiProperty({ example: 'device-unique-id' })
  @IsString()
  deviceId: string;

  @ApiProperty({ example: 'base64-encoded-public-key' })
  @IsString()
  publicKey: string;
}
