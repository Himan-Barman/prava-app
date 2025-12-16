import { Controller, Get, Post, Delete, Body, Param, UseGuards } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth } from '@nestjs/swagger';
import { KeysService } from './keys.service';
import { RegisterE2EEKeyDto } from './dto/keys.dto';
import { JwtAuthGuard } from '../common/guards/jwt-auth.guard';
import { CurrentUser } from '../common/decorators/current-user.decorator';

@ApiTags('keys')
@Controller('keys')
@UseGuards(JwtAuthGuard)
@ApiBearerAuth()
export class KeysController {
  constructor(private keysService: KeysService) {}

  @Post('register')
  @ApiOperation({ summary: 'Register E2EE public key for device' })
  async registerKey(@CurrentUser() user: any, @Body() dto: RegisterE2EEKeyDto) {
    return this.keysService.registerKey(user.id, dto);
  }

  @Get('my-keys')
  @ApiOperation({ summary: 'Get current user E2EE keys' })
  async getKeys(@CurrentUser() user: any) {
    return this.keysService.getKeys(user.id);
  }

  @Get('user/:userId')
  @ApiOperation({ summary: 'Get E2EE keys for a user' })
  async getUserKeys(@Param('userId') userId: string) {
    return this.keysService.getUserKeys(userId);
  }

  @Delete('device/:deviceId')
  @ApiOperation({ summary: 'Delete E2EE key for device' })
  async deleteKey(@CurrentUser() user: any, @Param('deviceId') deviceId: string) {
    return this.keysService.deleteKey(user.id, deviceId);
  }
}
