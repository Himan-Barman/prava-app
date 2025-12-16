import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _otpSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _sendOtp() async {
    if (_formKey.currentState?.validate() ?? false) {
      await ref.read(authProvider.notifier).sendOtp(_emailController.text);
      setState(() {
        _otpSent = true;
      });
    }
  }

  Future<void> _verifyOtp() async {
    if (_otpController.text.isNotEmpty) {
      await ref.read(authProvider.notifier).verifyOtp(
            _emailController.text,
            _otpController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo/Icon
                  Icon(
                    Icons.message_rounded,
                    size: 80,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  
                  // Title
                  Text(
                    'Welcome to Prava',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  
                  // Subtitle
                  Text(
                    'Connect with friends and the world',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),
                  
                  // Email field
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    enabled: !_otpSent && !authState.isLoading,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      hintText: 'Enter your email',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!value.contains('@')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // OTP field (shown after OTP sent)
                  if (_otpSent) ...[
                    TextFormField(
                      controller: _otpController,
                      keyboardType: TextInputType.number,
                      enabled: !authState.isLoading,
                      decoration: const InputDecoration(
                        labelText: 'OTP Code',
                        hintText: 'Enter 6-digit code',
                        prefixIcon: Icon(Icons.lock_outlined),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  
                  // Error message
                  if (authState.error != null) ...[
                    Text(
                      authState.error!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                  ],
                  
                  // Submit button
                  FilledButton(
                    onPressed: authState.isLoading
                        ? null
                        : (_otpSent ? _verifyOtp : _sendOtp),
                    child: authState.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(_otpSent ? 'Verify OTP' : 'Send OTP'),
                  ),
                  
                  // Back button (when OTP sent)
                  if (_otpSent) ...[
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: authState.isLoading
                          ? null
                          : () {
                              setState(() {
                                _otpSent = false;
                                _otpController.clear();
                              });
                            },
                      child: const Text('Use different email'),
                    ),
                  ],
                  
                  const SizedBox(height: 24),
                  
                  // Divider with "or"
                  Row(
                    children: [
                      const Expanded(child: Divider()),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'or',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                      const Expanded(child: Divider()),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // Magic link button
                  OutlinedButton.icon(
                    onPressed: authState.isLoading
                        ? null
                        : () async {
                            if (_formKey.currentState?.validate() ?? false) {
                              await ref
                                  .read(authProvider.notifier)
                                  .sendMagicLink(_emailController.text);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Magic link sent to your email!'),
                                  ),
                                );
                              }
                            }
                          },
                    icon: const Icon(Icons.link),
                    label: const Text('Send Magic Link'),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // TODO notice
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Mock Mode',
                          style: Theme.of(context).textTheme.titleSmall,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'This is a demo. Any OTP code will work!',
                          style: Theme.of(context).textTheme.bodySmall,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
