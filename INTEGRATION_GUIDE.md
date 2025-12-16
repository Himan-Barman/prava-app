# Prava App Integration Guide

This guide explains how to integrate and extend the Prava application with additional features.

## Architecture Overview

### Backend (NestJS)
- **Modular architecture**: Each feature (auth, feed, chat, etc.) is a separate NestJS module
- **Prisma ORM**: Database access through Prisma for type safety
- **JWT Authentication**: Stateless authentication with refresh tokens
- **WebSocket Gateway**: Real-time communication for chat features
- **Redis**: Session management and caching

### Frontend (Flutter)
- **Riverpod**: State management with providers
- **go_router**: Declarative routing with authentication guards
- **Dio**: HTTP client with interceptors for authentication
- **Secure Storage**: Encrypted storage for sensitive data
- **WebSocket**: Real-time chat using socket.io_client

## Adding New Features

### Backend: Adding a New Module

1. **Generate Module Structure**:
```bash
cd backend
nest g module feature-name
nest g controller feature-name
nest g service feature-name
```

2. **Create DTOs** in `src/feature-name/dto/`:
```typescript
// feature.dto.ts
import { IsString } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class CreateFeatureDto {
  @ApiProperty()
  @IsString()
  name: string;
}
```

3. **Update Prisma Schema** if needed:
```prisma
// prisma/schema.prisma
model Feature {
  id        String   @id @default(uuid())
  name      String
  userId    String
  user      User     @relation(fields: [userId], references: [id])
  createdAt DateTime @default(now())
  
  @@map("features")
}
```

4. **Run Migration**:
```bash
npm run prisma:migrate
```

5. **Implement Service**:
```typescript
// feature.service.ts
@Injectable()
export class FeatureService {
  constructor(private prisma: PrismaService) {}

  async create(userId: string, dto: CreateFeatureDto) {
    return this.prisma.feature.create({
      data: { name: dto.name, userId },
    });
  }
}
```

6. **Implement Controller**:
```typescript
// feature.controller.ts
@Controller('features')
@UseGuards(JwtAuthGuard)
@ApiBearerAuth()
export class FeatureController {
  constructor(private featureService: FeatureService) {}

  @Post()
  create(@CurrentUser() user: any, @Body() dto: CreateFeatureDto) {
    return this.featureService.create(user.id, dto);
  }
}
```

7. **Import Module** in `app.module.ts`

### Frontend: Adding a New Feature

1. **Create Feature Structure**:
```
lib/features/feature-name/
├── data/
│   ├── feature_api_service.dart
│   └── feature_repository.dart
├── domain/
│   └── feature_model.dart
└── presentation/
    ├── feature_screen.dart
    └── feature_controller.dart
```

2. **Create Model**:
```dart
// feature_model.dart
class Feature {
  final String id;
  final String name;

  Feature({required this.id, required this.name});

  factory Feature.fromJson(Map<String, dynamic> json) {
    return Feature(
      id: json['id'],
      name: json['name'],
    );
  }
}
```

3. **Create API Service**:
```dart
// feature_api_service.dart
class FeatureApiService {
  final ApiClient _apiClient;

  FeatureApiService(this._apiClient);

  Future<Feature> create(String name) async {
    final response = await _apiClient.dio.post('/features', 
      data: {'name': name}
    );
    return Feature.fromJson(response.data);
  }
}

final featureApiServiceProvider = Provider<FeatureApiService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return FeatureApiService(apiClient);
});
```

4. **Create Controller**:
```dart
// feature_controller.dart
class FeatureController extends StateNotifier<AsyncValue<List<Feature>>> {
  final FeatureApiService _api;

  FeatureController(this._api) : super(const AsyncValue.loading()) {
    loadFeatures();
  }

  Future<void> loadFeatures() async {
    state = const AsyncValue.loading();
    try {
      final features = await _api.getAll();
      state = AsyncValue.data(features);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

final featureControllerProvider = 
  StateNotifierProvider<FeatureController, AsyncValue<List<Feature>>>((ref) {
    final api = ref.watch(featureApiServiceProvider);
    return FeatureController(api);
  });
```

5. **Create Screen**:
```dart
// feature_screen.dart
class FeatureScreen extends ConsumerWidget {
  const FeatureScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final featuresState = ref.watch(featureControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Features')),
      body: featuresState.when(
        data: (features) => ListView.builder(
          itemCount: features.length,
          itemBuilder: (context, index) {
            final feature = features[index];
            return ListTile(title: Text(feature.name));
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
```

6. **Add Route** in `app_router_config.dart`:
```dart
GoRoute(
  path: '/features',
  name: 'features',
  builder: (context, state) => const FeatureScreen(),
),
```

## WebSocket Integration

### Backend: Adding WebSocket Events

In `chat.gateway.ts`:
```typescript
@SubscribeMessage('custom_event')
handleCustomEvent(@ConnectedSocket() client: Socket, @MessageBody() data: any) {
  // Handle event
  this.server.emit('custom_response', { data });
}
```

### Frontend: Listening to WebSocket Events

In your controller:
```dart
void listenToCustomEvents() {
  final wsClient = ref.read(webSocketClientProvider);
  wsClient.onCustomEvent((data) {
    // Handle event
    print('Received: $data');
  });
}
```

## Database Migrations

### Creating a Migration
```bash
cd backend
npm run prisma:migrate -- --name add_feature_table
```

### Applying Migrations in Production
```bash
npm run prisma:migrate:prod
```

## Testing

### Backend Unit Tests
```typescript
// feature.service.spec.ts
describe('FeatureService', () => {
  let service: FeatureService;
  let prisma: PrismaService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [FeatureService, PrismaService],
    }).compile();

    service = module.get<FeatureService>(FeatureService);
    prisma = module.get<PrismaService>(PrismaService);
  });

  it('should create feature', async () => {
    const dto = { name: 'Test Feature' };
    const result = await service.create('user-id', dto);
    expect(result.name).toBe(dto.name);
  });
});
```

### Frontend Widget Tests
```dart
// feature_screen_test.dart
void main() {
  testWidgets('FeatureScreen displays features', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(home: FeatureScreen()),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.text('Features'), findsOneWidget);
  });
}
```

## Security Best Practices

1. **Always use JWT auth guard** for protected endpoints
2. **Validate all input** using DTOs with class-validator
3. **Sanitize user input** to prevent XSS and SQL injection
4. **Use HTTPS** in production
5. **Set strong JWT secrets** (never commit to repo)
6. **Implement rate limiting** for sensitive endpoints
7. **Use secure storage** for tokens on mobile

## Performance Optimization

### Backend
- Use Redis for caching frequently accessed data
- Implement pagination for large datasets
- Use database indexes for frequently queried fields
- Optimize Prisma queries with `select` and `include`

### Frontend
- Use `const` constructors where possible
- Implement pagination in lists
- Cache API responses with Riverpod
- Use `AutoDisposeProvider` for temporary state

## Deployment Checklist

### Backend
- [ ] Set production environment variables
- [ ] Run database migrations
- [ ] Set up SSL/TLS certificates
- [ ] Configure CORS for production domains
- [ ] Set up monitoring and logging
- [ ] Configure backup strategy for database

### Frontend
- [ ] Update API base URL to production
- [ ] Build release version
- [ ] Test on physical devices
- [ ] Set up crash reporting (e.g., Sentry)
- [ ] Configure deep linking
- [ ] Test offline functionality

## Common Issues and Solutions

### Backend

**Issue**: "Cannot connect to database"
- Solution: Ensure PostgreSQL is running (`docker-compose up -d`)

**Issue**: "JWT token expired"
- Solution: Implement token refresh logic (already included)

### Frontend

**Issue**: "DioException: Connection timeout"
- Solution: Check API base URL and ensure backend is running

**Issue**: "Null check operator used on a null value"
- Solution: Use null-safe operators (`?.` or `??`)

## Resources

- [NestJS Documentation](https://docs.nestjs.com/)
- [Prisma Guides](https://www.prisma.io/docs/guides)
- [Flutter Best Practices](https://docs.flutter.dev/perf/best-practices)
- [Riverpod Documentation](https://riverpod.dev/docs/introduction/getting_started)

## Support

For issues or questions:
1. Check existing GitHub issues
2. Review API documentation at `http://localhost:3000/api`
3. Consult this guide and main README
