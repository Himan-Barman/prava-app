import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/feed_repository.dart';
import '../../domain/repositories/chat_repository.dart';
import '../../domain/repositories/search_repository.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../domain/services/crypto_service.dart';
import '../../data/repositories/mock_auth_repository.dart';
import '../../data/repositories/mock_feed_repository.dart';
import '../../data/repositories/mock_chat_repository.dart';
import '../../data/repositories/mock_search_repository.dart';
import '../../data/repositories/mock_profile_repository.dart';

/// Provider for AuthRepository
/// 
/// TODO: Replace with real implementation based on environment
/// Use AppConfig to determine which implementation to use
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return MockAuthRepository();
});

/// Provider for FeedRepository
final feedRepositoryProvider = Provider<FeedRepository>((ref) {
  return MockFeedRepository();
});

/// Provider for ChatRepository
final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return MockChatRepository();
});

/// Provider for SearchRepository
final searchRepositoryProvider = Provider<SearchRepository>((ref) {
  return MockSearchRepository();
});

/// Provider for ProfileRepository
final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return MockProfileRepository();
});

/// Provider for CryptoService
final cryptoServiceProvider = Provider<CryptoService>((ref) {
  return MockCryptoService();
});
