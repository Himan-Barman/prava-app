import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  static String get apiBaseUrl => dotenv.get('API_BASE_URL', fallback: 'http://localhost:3000');
  static String get wsUrl => dotenv.get('WS_URL', fallback: 'http://localhost:3000');
  static String get appEnv => dotenv.get('APP_ENV', fallback: 'development');
  
  static bool get isDevelopment => appEnv == 'development';
  static bool get isProduction => appEnv == 'production';
}
