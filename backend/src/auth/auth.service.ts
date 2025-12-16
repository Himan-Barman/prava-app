import {
  Injectable,
  UnauthorizedException,
  ConflictException,
  BadRequestException,
} from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import * as bcrypt from 'bcrypt';
import { PrismaService } from '../prisma.service';
import { RedisService } from '../redis.service';
import { RegisterDto, LoginDto, VerifyOtpDto } from './dto/auth.dto';

@Injectable()
export class AuthService {
  constructor(
    private prisma: PrismaService,
    private jwtService: JwtService,
    private redis: RedisService,
  ) {}

  async register(dto: RegisterDto) {
    // Check if email already exists
    const existingUser = await this.prisma.user.findUnique({
      where: { email: dto.email },
    });
    if (existingUser) {
      throw new ConflictException('Email already exists');
    }

    // Check if username already exists
    const existingUsername = await this.prisma.user.findUnique({
      where: { username: dto.username },
    });
    if (existingUsername) {
      throw new ConflictException('Username already exists');
    }

    // Hash password
    const passwordHash = await bcrypt.hash(dto.password, 10);

    // Create user
    const user = await this.prisma.user.create({
      data: {
        email: dto.email,
        username: dto.username,
        passwordHash,
        displayName: dto.displayName || dto.username,
      },
    });

    // Generate and send OTP
    await this.generateAndSendOtp(user.email, user.id, 'verify');

    return {
      message: 'Registration successful. Please verify your email with the OTP sent.',
      userId: user.id,
    };
  }

  async login(dto: LoginDto) {
    const user = await this.validateUser(dto.email, dto.password);
    if (!user) {
      throw new UnauthorizedException('Invalid credentials');
    }

    if (!user.isVerified) {
      // Generate and send OTP for login
      await this.generateAndSendOtp(user.email, user.id, 'verify');
      throw new UnauthorizedException('Email not verified. OTP sent to your email.');
    }

    return this.generateTokens(user);
  }

  async verifyOtp(dto: VerifyOtpDto) {
    const otp = await this.prisma.otpCode.findFirst({
      where: {
        email: dto.email,
        code: dto.code,
        expiresAt: { gte: new Date() },
      },
      include: { user: true },
    });

    if (!otp) {
      throw new BadRequestException('Invalid or expired OTP');
    }

    // Mark user as verified
    if (otp.user) {
      await this.prisma.user.update({
        where: { id: otp.user.id },
        data: { isVerified: true },
      });
    }

    // Delete used OTP
    await this.prisma.otpCode.delete({ where: { id: otp.id } });

    if (otp.user) {
      return this.generateTokens(otp.user);
    }

    return { message: 'Email verified successfully' };
  }

  async refreshToken(refreshToken: string) {
    const storedToken = await this.prisma.refreshToken.findUnique({
      where: { token: refreshToken },
      include: { user: true },
    });

    if (!storedToken || storedToken.expiresAt < new Date()) {
      throw new UnauthorizedException('Invalid or expired refresh token');
    }

    return this.generateTokens(storedToken.user);
  }

  async validateUser(email: string, password: string) {
    const user = await this.prisma.user.findUnique({ where: { email } });
    if (user && (await bcrypt.compare(password, user.passwordHash))) {
      return user;
    }
    return null;
  }

  private async generateTokens(user: any) {
    const payload = { sub: user.id, email: user.email, username: user.username };

    const accessToken = this.jwtService.sign(payload);
    const refreshToken = this.jwtService.sign(payload, {
      secret: process.env.REFRESH_TOKEN_SECRET || 'refresh-secret',
      expiresIn: process.env.REFRESH_TOKEN_EXPIRES_IN || '7d',
    });

    // Store refresh token
    const expiresAt = new Date();
    expiresAt.setDate(expiresAt.getDate() + 7);
    await this.prisma.refreshToken.create({
      data: {
        token: refreshToken,
        userId: user.id,
        expiresAt,
      },
    });

    return {
      accessToken,
      refreshToken,
      user: {
        id: user.id,
        email: user.email,
        username: user.username,
        displayName: user.displayName,
        avatarUrl: user.avatarUrl,
      },
    };
  }

  private async generateAndSendOtp(email: string, userId: string, purpose: string) {
    // Generate 6-digit OTP
    const code = Math.floor(100000 + Math.random() * 900000).toString();

    const expiresAt = new Date();
    const expiresInMinutes = parseInt(process.env.OTP_EXPIRES_IN_MINUTES || '10', 10);
    expiresAt.setMinutes(expiresAt.getMinutes() + expiresInMinutes);

    await this.prisma.otpCode.create({
      data: {
        code,
        email,
        userId,
        purpose,
        expiresAt,
      },
    });

    // TODO: Send email with OTP (integrate with email service)
    // WARNING: For development only - remove in production!
    // Replace with proper email service (e.g., SendGrid, AWS SES)
    if (process.env.NODE_ENV === 'development') {
      console.log(`[DEV ONLY] OTP for ${email}: ${code}`);
    }

    return code;
  }

  async resendOtp(email: string) {
    const user = await this.prisma.user.findUnique({ where: { email } });
    if (!user) {
      throw new BadRequestException('User not found');
    }

    // Delete old OTPs
    await this.prisma.otpCode.deleteMany({
      where: { email },
    });

    await this.generateAndSendOtp(email, user.id, 'verify');

    return { message: 'OTP sent successfully' };
  }
}
