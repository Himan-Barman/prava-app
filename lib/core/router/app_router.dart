import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../navigation/main_navigation.dart';

/// App router configuration with go_router
final goRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/feed',
    redirect: (context, state) {
      final isAuthenticated = authState.isAuthenticated;
      final isAuthRoute = state.matchedLocation.startsWith('/auth');

      // Redirect to login if not authenticated and not on auth route
      if (!isAuthenticated && !isAuthRoute) {
        return '/auth/login';
      }

      // Redirect to feed if authenticated and on auth route
      if (isAuthenticated && isAuthRoute) {
        return '/feed';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/auth/login',
        builder: (context, state) => const LoginScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) {
          return MainNavigation(child: child);
        },
        routes: [
          GoRoute(
            path: '/feed',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: FeedPlaceholder(),
            ),
            routes: [
              GoRoute(
                path: 'post/:id',
                builder: (context, state) {
                  final postId = state.pathParameters['id']!;
                  return PostDetailPlaceholder(postId: postId);
                },
              ),
              GoRoute(
                path: 'create',
                builder: (context, state) => const CreatePostPlaceholder(),
              ),
            ],
          ),
          GoRoute(
            path: '/search',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: SearchPlaceholder(),
            ),
          ),
          GoRoute(
            path: '/chats',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ChatsPlaceholder(),
            ),
            routes: [
              GoRoute(
                path: ':id',
                builder: (context, state) {
                  final conversationId = state.pathParameters['id']!;
                  return ChatThreadPlaceholder(conversationId: conversationId);
                },
              ),
            ],
          ),
          GoRoute(
            path: '/profile',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ProfilePlaceholder(),
            ),
            routes: [
              GoRoute(
                path: 'edit',
                builder: (context, state) => const EditProfilePlaceholder(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});

// Temporary placeholders - will be replaced with actual screens
class FeedPlaceholder extends StatelessWidget {
  const FeedPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Feed Screen'));
  }
}

class SearchPlaceholder extends StatelessWidget {
  const SearchPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Search Screen'));
  }
}

class ChatsPlaceholder extends StatelessWidget {
  const ChatsPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Chats Screen'));
  }
}

class ProfilePlaceholder extends StatelessWidget {
  const ProfilePlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Profile Screen'));
  }
}

class PostDetailPlaceholder extends StatelessWidget {
  const PostDetailPlaceholder({super.key, required this.postId});

  final String postId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Post Detail')),
      body: Center(child: Text('Post ID: $postId')),
    );
  }
}

class CreatePostPlaceholder extends StatelessWidget {
  const CreatePostPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Post')),
      body: const Center(child: Text('Create Post Screen')),
    );
  }
}

class ChatThreadPlaceholder extends StatelessWidget {
  const ChatThreadPlaceholder({super.key, required this.conversationId});

  final String conversationId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat')),
      body: Center(child: Text('Conversation ID: $conversationId')),
    );
  }
}

class EditProfilePlaceholder extends StatelessWidget {
  const EditProfilePlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: const Center(child: Text('Edit Profile Screen')),
    );
  }
}
