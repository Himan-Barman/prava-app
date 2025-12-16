import { Injectable } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';

/**
 * JWT Authentication Guard
 * 
 * Protects routes by validating JWT tokens in the Authorization header.
 * Uses the JWT strategy defined in auth module.
 * 
 * @example
 * @UseGuards(JwtAuthGuard)
 * @Get('protected')
 * getProtectedResource() { ... }
 */
@Injectable()
export class JwtAuthGuard extends AuthGuard('jwt') {}
