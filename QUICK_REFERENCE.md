# Prava App - Quick Reference Card

## 🚀 Quick Start Commands

### First Time Setup

**Backend:**
```bash
cd backend
npm install
docker-compose up -d
npm run prisma:generate
npm run prisma:migrate
npm run prisma:seed
npm run start:dev
```

**Frontend:**
```bash
flutter pub get
flutter run
```

### Daily Development

**Backend:**
```bash
cd backend
docker-compose up -d      # Start DB & Redis
npm run start:dev         # Start backend
```

**Frontend:**
```bash
flutter run               # Start app
```

## 📡 API Endpoints

**Base URL:** `http://localhost:3000`

### Authentication
- `POST /auth/register` - Register user
- `POST /auth/login` - Login
- `POST /auth/verify-otp` - Verify OTP
- `POST /auth/refresh` - Refresh token
- `POST /auth/resend-otp` - Resend OTP

### Users
- `GET /users/check-username/:username` - Check availability
- `GET /users/profile` - Get profile (auth)
- `PUT /users/profile` - Update profile (auth)
- `GET /users/search?q=query` - Search users (auth)

### Feed
- `GET /feed/posts` - Get posts (auth)
- `POST /feed/posts` - Create post (auth)
- `POST /feed/posts/:id/comments` - Add comment (auth)
- `POST /feed/posts/:id/reactions` - React (auth)

### Chat
- `GET /chat/conversations` - List chats (auth)
- `POST /chat/conversations` - Create chat (auth)
- `GET /chat/conversations/:id/messages` - Get messages (auth)
- `POST /chat/conversations/:id/messages` - Send message (auth)

### WebSocket
- URL: `ws://localhost:3000`
- Auth: Send JWT in `auth.token`
- Events: `join_conversation`, `new_message`, `typing_start/stop`

## 🔑 Demo Credentials

```
Email: alice@example.com
Password: password123

Email: bob@example.com
Password: password123
```

## 📚 Documentation Links

- **Swagger UI:** http://localhost:3000/api
- **Main README:** [README.md](./README.md)
- **Backend Docs:** [backend/README.md](./backend/README.md)
- **Integration Guide:** [INTEGRATION_GUIDE.md](./INTEGRATION_GUIDE.md)
- **Implementation Summary:** [IMPLEMENTATION_SUMMARY.md](./IMPLEMENTATION_SUMMARY.md)

## 🛠️ Development Commands

### Backend

```bash
npm run start:dev         # Dev with hot-reload
npm run build             # Build for production
npm run start:prod        # Run production build
npm run lint              # Lint code
npm run format            # Format code
npm test                  # Run tests
npm run prisma:studio     # Open database GUI
npm run prisma:migrate    # Run migrations
npm run prisma:generate   # Generate Prisma client
```

### Frontend

```bash
flutter run               # Run on device
flutter run -d chrome     # Run on web
flutter test              # Run tests
flutter analyze           # Analyze code
dart format .             # Format code
flutter build apk         # Build Android
flutter build ios         # Build iOS
```

## 🐳 Docker Commands

```bash
docker-compose up -d      # Start services
docker-compose down       # Stop services
docker-compose logs -f    # View logs
docker-compose ps         # List services
docker-compose restart    # Restart services
```

## 🔍 Troubleshooting

### Backend won't start
```bash
docker-compose down -v
docker-compose up -d
npm run prisma:migrate
```

### Frontend build errors
```bash
flutter clean
flutter pub get
flutter pub upgrade
```

### Database issues
```bash
cd backend
npm run prisma:migrate reset  # ⚠️ Deletes all data!
npm run prisma:seed
```

### Port already in use
```bash
# Backend (port 3000)
lsof -ti:3000 | xargs kill -9

# PostgreSQL (port 5432)
docker-compose restart postgres

# Redis (port 6379)
docker-compose restart redis
```

## 📁 Project Structure

```
prava-app/
├── backend/              # NestJS API
│   ├── src/             # Source code
│   ├── prisma/          # Database
│   └── docker-compose.yml
├── lib/                 # Flutter app
│   ├── core/           # Core services
│   └── features/       # Features
├── .github/workflows/   # CI/CD
└── *.md                # Documentation
```

## 🌍 Environment Files

**Backend:** `backend/.env`
```env
DATABASE_URL=postgresql://prava:prava123@localhost:5432/prava_db
REDIS_HOST=localhost
REDIS_PORT=6379
JWT_SECRET=your-secret
```

**Frontend:** `.env`
```env
API_BASE_URL=http://localhost:3000
WS_URL=http://localhost:3000
APP_ENV=development
```

## 🔐 Security Notes

- Change JWT secrets in production
- Never commit `.env` files
- Use HTTPS in production
- Rate limiting enabled on auth endpoints
- Tokens stored securely on mobile

## 📊 Service Ports

| Service | Port | URL |
|---------|------|-----|
| Backend API | 3000 | http://localhost:3000 |
| Swagger Docs | 3000 | http://localhost:3000/api |
| PostgreSQL | 5432 | localhost:5432 |
| Redis | 6379 | localhost:6379 |
| Prisma Studio | 5555 | http://localhost:5555 |

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
flutter test --coverage   # With coverage
```

## 📝 Common Tasks

### Add New User
```bash
# Via API (POST /auth/register)
curl -X POST http://localhost:3000/auth/register \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","username":"testuser","password":"password123"}'
```

### Check Database
```bash
cd backend
npm run prisma:studio
# Opens GUI at http://localhost:5555
```

### Reset Everything
```bash
cd backend
docker-compose down -v
docker-compose up -d
npm run prisma:migrate
npm run prisma:seed
```

## 🆘 Getting Help

1. Check error messages carefully
2. Review documentation files
3. Check Swagger UI for API details
4. Inspect browser/mobile console
5. Check backend logs: `docker-compose logs -f`
6. Review [INTEGRATION_GUIDE.md](./INTEGRATION_GUIDE.md)

## 🎯 Next Steps

1. ✅ Set up development environment
2. ✅ Run backend and frontend
3. ✅ Test with demo users
4. 📝 Complete API integration for all screens
5. 🎨 Customize UI/theme
6. 🔧 Add new features
7. 🚀 Deploy to production

---

**Need More Details?** Check the full documentation:
- [README.md](./README.md) - Main documentation
- [INTEGRATION_GUIDE.md](./INTEGRATION_GUIDE.md) - How to extend
- [IMPLEMENTATION_SUMMARY.md](./IMPLEMENTATION_SUMMARY.md) - What was built
