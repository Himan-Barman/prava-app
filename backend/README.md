# Prava Backend API

NestJS-based backend API for the Prava application with PostgreSQL, Redis, and WebSocket support.

## Features

- **Authentication**: Email/password + OTP verification, JWT + Refresh tokens
- **Users**: Profile management, username uniqueness check, user search
- **Feed**: Posts, comments, reactions
- **Chat**: Real-time messaging with WebSocket, conversations, typing indicators
- **Notifications**: Push token registration, notification management
- **E2EE Keys**: End-to-end encryption key management (stubs)
- **Security**: Rate limiting, CORS, validation, JWT authentication
- **Documentation**: OpenAPI/Swagger docs at `/api`

## Prerequisites

- Node.js 18+ and npm
- Docker and Docker Compose (for PostgreSQL and Redis)

## Setup

### 1. Install dependencies

```bash
npm install
```

### 2. Configure environment

Copy `.env.example` to `.env` and update values if needed:

```bash
cp .env.example .env
```

Key environment variables:
- `DATABASE_URL`: PostgreSQL connection string
- `REDIS_HOST`, `REDIS_PORT`: Redis connection
- `JWT_SECRET`, `REFRESH_TOKEN_SECRET`: JWT secrets (change in production!)
- `PORT`: Server port (default: 3000)

### 3. Start PostgreSQL and Redis

```bash
docker-compose up -d
```

This starts:
- PostgreSQL on port 5432
- Redis on port 6379

### 4. Run database migrations

```bash
npm run prisma:generate
npm run prisma:migrate
```

### 5. Seed development data (optional)

```bash
npm run prisma:seed
```

This creates demo users (alice@example.com / bob@example.com, password: password123), posts, and conversations.

## Running the Application

### Development mode

```bash
npm run start:dev
```

The API will be available at `http://localhost:3000`
Swagger documentation: `http://localhost:3000/api`

### Production mode

```bash
npm run build
npm run start:prod
```

## API Endpoints

### Authentication
- `POST /auth/register` - Register new user
- `POST /auth/login` - Login with email/password
- `POST /auth/verify-otp` - Verify email with OTP
- `POST /auth/refresh` - Refresh access token
- `POST /auth/resend-otp` - Resend OTP

### Users
- `GET /users/check-username/:username` - Check username availability
- `GET /users/profile` - Get current user profile (auth required)
- `PUT /users/profile` - Update profile (auth required)
- `GET /users/search?q=query` - Search users (auth required)
- `GET /users/:userId` - Get user by ID (auth required)

### Feed
- `POST /feed/posts` - Create post (auth required)
- `GET /feed/posts` - Get feed posts (auth required)
- `GET /feed/posts/:postId` - Get post details (auth required)
- `DELETE /feed/posts/:postId` - Delete post (auth required)
- `POST /feed/posts/:postId/comments` - Add comment (auth required)
- `POST /feed/posts/:postId/reactions` - Add/remove reaction (auth required)

### Chat
- `POST /chat/conversations` - Create conversation (auth required)
- `GET /chat/conversations` - Get conversations (auth required)
- `GET /chat/conversations/:id` - Get conversation details (auth required)
- `GET /chat/conversations/:id/messages` - Get messages (auth required)
- `POST /chat/conversations/:id/messages` - Send message (auth required)
- `POST /chat/conversations/:id/read` - Mark as read (auth required)

### WebSocket Events
Connect to WebSocket with JWT token in auth header:
```javascript
const socket = io('http://localhost:3000', {
  auth: { token: 'your-jwt-token' }
});
```

Events:
- `join_conversation` - Join a conversation room
- `leave_conversation` - Leave a conversation room
- `typing_start` - Notify typing started
- `typing_stop` - Notify typing stopped
- `new_message` - Receive new message
- `user_typing` - Receive typing notification

### Notifications
- `POST /notifications/register-push-token` - Register push token (auth required)
- `GET /notifications` - Get notifications (auth required)
- `PUT /notifications/:id/read` - Mark as read (auth required)
- `PUT /notifications/read-all` - Mark all as read (auth required)

### E2EE Keys
- `POST /keys/register` - Register public key (auth required)
- `GET /keys/my-keys` - Get own keys (auth required)
- `GET /keys/user/:userId` - Get user's public keys (auth required)
- `DELETE /keys/device/:deviceId` - Delete key (auth required)

## Database Management

### Generate Prisma Client
```bash
npm run prisma:generate
```

### Create Migration
```bash
npm run prisma:migrate
```

### Prisma Studio (Database GUI)
```bash
npm run prisma:studio
```

## Testing

```bash
# Unit tests
npm test

# E2E tests
npm run test:e2e

# Test coverage
npm run test:cov
```

## Linting and Formatting

```bash
# Lint
npm run lint

# Format
npm run format
```

## Project Structure

```
backend/
├── prisma/
│   ├── schema.prisma      # Database schema
│   └── seed.ts            # Seed data
├── src/
│   ├── auth/              # Authentication module
│   ├── users/             # Users module
│   ├── feed/              # Feed module
│   ├── chat/              # Chat module (REST + WebSocket)
│   ├── notifications/     # Notifications module
│   ├── keys/              # E2EE keys module
│   ├── common/            # Shared guards, decorators, etc.
│   ├── prisma.service.ts  # Prisma service
│   ├── redis.service.ts   # Redis service
│   ├── app.module.ts      # Root module
│   └── main.ts            # Application entry point
├── docker-compose.yml     # PostgreSQL + Redis
├── .env.example           # Environment variables template
└── package.json
```

## Extending the Application

### Adding a New Module

1. Generate module:
   ```bash
   nest g module feature-name
   nest g controller feature-name
   nest g service feature-name
   ```

2. Create DTOs in `src/feature-name/dto/`
3. Add routes to controller
4. Implement business logic in service
5. Import module in `app.module.ts`

### Adding Database Models

1. Update `prisma/schema.prisma`
2. Run migration:
   ```bash
   npm run prisma:migrate
   ```
3. Update seed file if needed

### Adding WebSocket Events

1. Add handlers in `src/chat/chat.gateway.ts`
2. Use `@SubscribeMessage()` decorator
3. Emit events using `this.server.emit()`

## Production Deployment

1. Set secure environment variables (strong JWT secrets, production DB)
2. Build the application: `npm run build`
3. Run migrations: `npm run prisma:migrate:prod`
4. Start: `npm run start:prod`
5. Use process manager (PM2) or container orchestration

## License

Private - Prava App
