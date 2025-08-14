import { Controller, Get, Post, Body, Headers, UnauthorizedException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';

@Controller()
export class AppController {
  constructor(private readonly jwt: JwtService) {}

  @Get('/health')
  health() {
    return { status: 'ok', ts: new Date().toISOString() };
  }

  @Get('/ready')
  ready() {
    return { ready: true };
  }

  // Simplified metrics endpoint (for demo)
  private reqCount = 0;
  @Get('/metrics')
  metrics() {
    this.reqCount += 1;
    return { requests_total: this.reqCount };
  }

  @Post('/auth/login')
  login(@Body() body: any) {
    if (body?.username && body?.password) {
      // demo only
      const token = this.jwt.sign({ sub: body.username });
      return { access_token: token };
    }
    throw new UnauthorizedException('invalid_credentials');
  }

  @Post('/echo')
  echo(@Body() body: any, @Headers('authorization') auth?: string) {
    if (!auth?.startsWith('Bearer ')) throw new UnauthorizedException('missing_token');
    try {
      const token = auth.slice('Bearer '.length);
      this.jwt.verify(token);
      return { ok: true, data: body };
    } catch {
      throw new UnauthorizedException('bad_token');
    }
  }
}
