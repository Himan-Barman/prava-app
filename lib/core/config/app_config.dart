/// Application configuration for environment settings and feature flags.
/// 
/// This class holds all the configuration needed to run the app,
/// including API endpoints, WebSocket URLs, and feature toggles.
class AppConfig {
  const AppConfig({
    required this.apiBaseUrl,
    required this.wsBaseUrl,
    required this.enableFirebase,
    required this.enableE2EE,
    required this.environment,
  });

  /// REST API base URL
  final String apiBaseUrl;

  /// WebSocket base URL for realtime features
  final String wsBaseUrl;

  /// Enable Firebase Cloud Messaging and notifications
  final bool enableFirebase;

  /// Enable end-to-end encryption features (future)
  final bool enableE2EE;

  /// Current environment (dev, staging, prod)
  final String environment;

  /// Development configuration with mock services
  static const dev = AppConfig(
    apiBaseUrl: 'http://localhost:3000/api',
    wsBaseUrl: 'ws://localhost:3000/ws',
    enableFirebase: false,
    enableE2EE: false,
    environment: 'dev',
  );

  /// Staging configuration
  static const staging = AppConfig(
    apiBaseUrl: 'https://staging-api.prava.app/api',
    wsBaseUrl: 'wss://staging-api.prava.app/ws',
    enableFirebase: true,
    enableE2EE: false,
    environment: 'staging',
  );

  /// Production configuration
  static const prod = AppConfig(
    apiBaseUrl: 'https://api.prava.app/api',
    wsBaseUrl: 'wss://api.prava.app/ws',
    enableFirebase: true,
    enableE2EE: true,
    environment: 'prod',
  );

  /// Current active configuration (defaults to dev)
  static AppConfig current = dev;
}
