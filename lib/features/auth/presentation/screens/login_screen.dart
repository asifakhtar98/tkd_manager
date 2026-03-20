import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tkd_saas/features/auth/presentation/bloc/authentication_bloc.dart';

/// A single unified login / sign-up screen.
///
/// The user enters email + password. A toggle link at the bottom switches
/// between **Sign In** and **Sign Up** mode — no extra details are collected,
/// making signup as frictionless as a single button tap.
///
/// All state (loading, error) is driven by [AuthenticationBloc].
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController(
    text: kDebugMode ? 'dev1@test.com' : null, 
  );
  final TextEditingController _passwordController = TextEditingController(
    text: kDebugMode ? '123456' : null,
  );

  bool _isSignUpMode = false;
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Actions
  // ───────────────────────────────────────────────────────────────────────────

  void _submitForm() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final String email = _emailController.text.trim();
    final String password = _passwordController.text;

    if (_isSignUpMode) {
      context.read<AuthenticationBloc>().add(
            AuthenticationSignUpRequested(email: email, password: password),
          );
    } else {
      context.read<AuthenticationBloc>().add(
            AuthenticationSignInRequested(email: email, password: password),
          );
    }
  }

  void _toggleAuthMode() {
    setState(() {
      _isSignUpMode = !_isSignUpMode;
    });
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Validators
  // ───────────────────────────────────────────────────────────────────────────

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required.';
    }
    // Simple regex — matches 99 % of real-world emails.
    final RegExp emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Enter a valid email address.';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required.';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters.';
    }
    return null;
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Build
  // ───────────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLowest,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: BlocConsumer<AuthenticationBloc, AuthenticationState>(
              listener: _authStateListener,
              builder: (BuildContext context, AuthenticationState state) {
                final bool isLoading = state is AuthenticationInProgress;

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ── Branding ──
                    _buildBrandingHeader(theme, colorScheme),
                    const SizedBox(height: 40),

                    // ── Card with form ──
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 36,
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                _isSignUpMode
                                    ? 'Create Account'
                                    : 'Welcome Back',
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.onSurface,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _isSignUpMode
                                    ? 'Sign up to get started'
                                    : 'Sign in to continue',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 32),

                              // ── Email field ──
                              TextFormField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                autofillHints: const [AutofillHints.email],
                                enabled: !isLoading,
                                decoration: const InputDecoration(
                                  labelText: 'Email',
                                  prefixIcon: Icon(Icons.email_outlined),
                                ),
                                validator: _validateEmail,
                              ),
                              const SizedBox(height: 20),

                              // ── Password field ──
                              TextFormField(
                                controller: _passwordController,
                                obscureText: !_isPasswordVisible,
                                textInputAction: TextInputAction.done,
                                autofillHints: _isSignUpMode
                                    ? const [AutofillHints.newPassword]
                                    : const [AutofillHints.password],
                                enabled: !isLoading,
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  prefixIcon:
                                      const Icon(Icons.lock_outline),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _isPasswordVisible
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _isPasswordVisible =
                                            !_isPasswordVisible;
                                      });
                                    },
                                  ),
                                ),
                                validator: _validatePassword,
                                onFieldSubmitted: (_) => _submitForm(),
                              ),
                              const SizedBox(height: 28),

                              // ── Submit button ──
                              SizedBox(
                                height: 48,
                                child: FilledButton(
                                  onPressed: isLoading ? null : _submitForm,
                                  child: isLoading
                                      ? const SizedBox(
                                          height: 22,
                                          width: 22,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.5,
                                            color: Colors.white,
                                          ),
                                        )
                                      : Text(
                                          _isSignUpMode
                                              ? 'Sign Up'
                                              : 'Sign In',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                ),
                              ),
                              const SizedBox(height: 16),

                              // ── Toggle link ──
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    _isSignUpMode
                                        ? 'Already have an account?'
                                        : "Don't have an account?",
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                  TextButton(
                                    onPressed: isLoading
                                        ? null
                                        : _toggleAuthMode,
                                    child: Text(
                                      _isSignUpMode ? 'Sign In' : 'Sign Up',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: colorScheme.primary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Branding
  // ───────────────────────────────────────────────────────────────────────────

  Widget _buildBrandingHeader(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.sports_martial_arts,
            size: 48,
            color: colorScheme.onPrimaryContainer,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'TKD Tournament Manager',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.primary,
          ),
        ),
      ],
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Listener — show snackbar on auth failure
  // ───────────────────────────────────────────────────────────────────────────

  void _authStateListener(
    BuildContext context,
    AuthenticationState state,
  ) {
    if (state is AuthenticationFailureState) {
      // Guard: the router redirect may have already unmounted this widget
      // by the time the listener fires on the next microtask.
      if (!context.mounted) return;

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(state.message),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
    }
  }
}
