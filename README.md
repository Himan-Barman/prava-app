# Prava App

A full-stack social messaging application built with Flutter (frontend) and NestJS (backend).

## 📱 Features

### Frontend (Flutter)
- **Authentication**: Email/password login + OTP verification
- **Feed**: Browse posts, comments, and reactions
- **Chat**: Real-time messaging with WebSocket support
- **Profile**: User profiles and settings
- **Search**: Find users by username
- **State Management**: Riverpod for reactive state
- **Routing**: go_router for navigation
- **Secure Storage**: Encrypted token storage
- **Theme**: Simple white/black/blue/red color scheme

### Backend (NestJS)
- **Authentication**: JWT + Refresh tokens, OTP verification
- **Users API**: Profile management, username availability check, user search
- **Feed API**: Posts, comments, reactions
- **Chat API**: Conversations, messages, WebSocket gateway for real-time chat
- **Notifications API**: Push token registration
- **E2EE Keys API**: End-to-end encryption key management (stubs)
- **Database**: PostgreSQL with Prisma ORM
- **Cache**: Redis for session management
- **Security**: Rate limiting, CORS, validation
- **Documentation**: OpenAPI/Swagger at `/api`

## 🚀 Quick Start

### Prerequisites

- **Frontend**: Flutter SDK 3.10+ ([Installation Guide](https://docs.flutter.dev/get-started/install))
- **Backend**: Node.js 18+, Docker & Docker Compose
- **Database**: Docker (for PostgreSQL and Redis)

### Backend Setup

1. Navigate to backend directory:
   ```bash
   cd backend
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

3. Start PostgreSQL and Redis:
   ```bash
   docker-compose up -d
   ```

4. Set up environment:
   ```bash
   cp .env.example .env
   # Edit .env with your configuration (optional for development)
   ```

5. Run migrations and seed data:
   ```bash
   npm run prisma:generate
   npm run prisma:migrate
   npm run prisma:seed
   ```

6. Start the development server:
   ```bash
   npm run start:dev
   ```

   The API will be available at `http://localhost:3000`  
   Swagger docs at `http://localhost:3000/api`

**Demo Users** (created by seed):
- Email: `alice@example.com`, Password: `password123`
- Email: `bob@example.com`, Password: `password123`

### Frontend Setup

1. Navigate to project root:
   ```bash
   cd /path/to/prava-app
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Set up environment:
   ```bash
   cp .env.example .env
   # Edit .env if needed (defaults to localhost:3000)
   ```

4. Run the app:
   ```bash
   # For development (connects to localhost:3000)
   flutter run
   
   # For iOS
   flutter run -d ios
   
   # For Android
   flutter run -d android
   ```

## 📂 Project Structure

```
prava-app/
├── backend/                 # NestJS backend
│   ├── prisma/             # Database schema and migrations
│   ├── src/
│   │   ├── auth/           # Authentication module
│   │   ├── users/          # Users/profiles module
│   │   ├── feed/           # Feed (posts/comments) module
│   │   ├── chat/           # Chat + WebSocket module
│   │   ├── notifications/  # Notifications module
│   │   ├── keys/           # E2EE keys module
│   │   └── common/         # Shared utilities
│   ├── docker-compose.yml  # PostgreSQL + Redis
│   └── README.md           # Backend documentation
│
├── lib/                    # Flutter frontend
│   ├── core/
│   │   ├── env/           # Environment configuration
│   │   ├── networking/    # API client, WebSocket
│   │   ├── local/         # Secure storage
│   │   ├── router/        # go_router configuration
│   │   └── theme/         # App theme
│   └── features/
│       ├── auth/          # Login, signup, verification
│       ├── feed/          # Feed screens
│       ├── chat/          # Chat screens
│       ├── profile/       # Profile screens
│       └── search/        # Search screens
│
├── .env.example           # Frontend environment template
├── .github/workflows/     # CI/CD pipelines
└── README.md             # This file
```

## 🛠️ Development

### Backend Commands

```bash
cd backend

# Development
npm run start:dev         # Start with hot-reload
npm run prisma:studio     # Open database GUI

# Testing
npm test                  # Run unit tests
npm run test:e2e          # Run e2e tests

# Linting
npm run lint              # Lint code
npm run format            # Format code

# Production
npm run build             # Build for production
npm run start:prod        # Run production build
```

### Frontend Commands

```bash
# Development
flutter run               # Run on connected device
flutter run -d chrome     # Run on web

# Testing
flutter test              # Run tests
flutter analyze           # Analyze code

# Linting
dart format .             # Format code

# Building
flutter build apk         # Build Android APK
flutter build ios         # Build iOS
flutter build web         # Build for web
```

## 🔧 Configuration

### Backend Environment Variables

Key variables in `backend/.env`:
```env
DATABASE_URL=postgresql://prava:prava123@localhost:5432/prava_db
REDIS_HOST=localhost
REDIS_PORT=6379
JWT_SECRET=your-secret-key
REFRESH_TOKEN_SECRET=your-refresh-secret
PORT=3000
```

See `backend/.env.example` for all options.

### Frontend Environment Variables

Key variables in `.env`:
```env
API_BASE_URL=http://localhost:3000
WS_URL=http://localhost:3000
APP_ENV=development
```

## 📡 API Endpoints

Full API documentation available at `http://localhost:3000/api` (Swagger UI).

**Key Endpoints:**
- `POST /auth/register` - Register new user
- `POST /auth/login` - Login
- `POST /auth/verify-otp` - Verify OTP
- `GET /users/check-username/:username` - Check username availability
- `GET /feed/posts` - Get feed
- `POST /feed/posts` - Create post
- `GET /chat/conversations` - Get conversations
- `POST /chat/conversations/:id/messages` - Send message
- WebSocket: `ws://localhost:3000` (with JWT auth)

## 🧪 Testing

### Backend Tests
```bash
cd backend
npm test                  # Unit tests
npm run test:e2e          # E2E tests
npm run test:cov          # Coverage
```

### Frontend Tests
```bash
flutter test              # All tests
flutter test test/unit    # Unit tests only
```

## 🚢 Deployment

### Backend Deployment

1. Set production environment variables
2. Run migrations: `npm run prisma:migrate:prod`
3. Build: `npm run build`
4. Start: `npm run start:prod`

Recommended: Use Docker or deploy to platforms like Railway, Render, or AWS.

### Frontend Deployment

**Android:**
```bash
flutter build apk --release
flutter build appbundle --release
```

**iOS:**
```bash
flutter build ios --release
```

**Web:**
```bash
flutter build web --release
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/my-feature`
3. Commit changes: `git commit -am 'Add my feature'`
4. Push: `git push origin feature/my-feature`
5. Create a Pull Request

## 📝 License

Private - Prava App

## 🔗 Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [NestJS Documentation](https://docs.nestjs.com/)
- [Prisma Documentation](https://www.prisma.io/docs/)
- [Riverpod Documentation](https://riverpod.dev/)
