import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tkd_saas/features/auth/presentation/bloc/authentication_bloc.dart';
import 'package:tkd_saas/features/auth/presentation/utils/auth_snackbar_listener.dart';
import 'package:tkd_saas/features/auth/presentation/utils/auth_validators.dart';
import 'package:tkd_saas/features/auth/presentation/widgets/auth_branding_header.dart';
import 'package:tkd_saas/features/auth/presentation/widgets/auth_submit_button.dart';
import 'package:tkd_saas/features/auth/presentation/widgets/password_text_form_field.dart';

/// Authentication mode for the login screen.
enum _AuthMode { signIn, signUp, forgotPassword }

/// A single unified login / sign-up / forgot-password screen.
///
/// The user enters email + password. Toggle links at the bottom switch
/// between modes. In forgot-password mode only the email field is shown.
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
    text: kDebugMode ? 'asak91298@gmail.com' : null,
  );
  final TextEditingController _passwordController = TextEditingController(
    text: kDebugMode ? '123456' : null,
  );
  final TextEditingController _organizationNameController = TextEditingController(
    text: kDebugMode ? 'Demo Org' : null,
  );

  _AuthMode _authMode = _AuthMode.signIn;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _organizationNameController.dispose();
    super.dispose();
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Actions
  // ───────────────────────────────────────────────────────────────────────────

  void _submitForm() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final String email = _emailController.text.trim();
    final AuthenticationBloc bloc = context.read<AuthenticationBloc>();

    switch (_authMode) {
      case _AuthMode.signIn:
        bloc.add(
          AuthenticationSignInRequested(
            email: email,
            password: _passwordController.text,
          ),
        );
      case _AuthMode.signUp:
        bloc.add(
          AuthenticationSignUpRequested(
            email: email,
            password: _passwordController.text,
            organizationName: _organizationNameController.text.trim(),
          ),
        );
      case _AuthMode.forgotPassword:
        bloc.add(AuthenticationPasswordResetRequested(email: email));
    }
  }

  void _switchToMode(_AuthMode mode) {
    setState(() {
      _authMode = mode;
      // Reset form validation and clear the password field so credentials
      // typed in one mode don't leak into another.
      _formKey.currentState?.reset();
      _passwordController.clear();
      _organizationNameController.clear();
    });
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Labels
  // ───────────────────────────────────────────────────────────────────────────

  String get _headerTitle => switch (_authMode) {
    _AuthMode.signIn => 'Welcome Back',
    _AuthMode.signUp => 'Create Account',
    _AuthMode.forgotPassword => 'Forgot Password',
  };

  String get _headerSubtitle => switch (_authMode) {
    _AuthMode.signIn => 'Sign in to continue',
    _AuthMode.signUp => 'Sign up to get started',
    _AuthMode.forgotPassword => 'Enter your email to receive a reset link',
  };

  String get _submitButtonLabel => switch (_authMode) {
    _AuthMode.signIn => 'Sign In',
    _AuthMode.signUp => 'Sign Up',
    _AuthMode.forgotPassword => 'Send Reset Link',
  };

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
                    const AuthBrandingHeader(
                      icon: Icons.sports_martial_arts,
                      title: 'TKD Tournament Manager',
                    ),
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
                        child: AutofillGroup(
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  _headerTitle,
                                  style: theme.textTheme.headlineSmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: colorScheme.onSurface,
                                      ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _headerSubtitle,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 32),

                                // ── Email field (always visible) ──
                                TextFormField(
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction:
                                      _authMode == _AuthMode.forgotPassword
                                      ? TextInputAction.done
                                      : TextInputAction.next,
                                  autofillHints: const [AutofillHints.email],
                                  enabled: !isLoading,
                                  decoration: const InputDecoration(
                                    labelText: 'Email',
                                    prefixIcon: Icon(Icons.email_outlined),
                                  ),
                                  validator: AuthValidators.validateEmail,
                                  onFieldSubmitted:
                                      _authMode == _AuthMode.forgotPassword
                                      ? (_) => _submitForm()
                                      : null,
                                ),

                                // ── Organization Name field (sign-up mode only) ──
                                if (_authMode == _AuthMode.signUp) ...[
                                  const SizedBox(height: 20),
                                  TextFormField(
                                    controller: _organizationNameController,
                                    keyboardType: TextInputType.name,
                                    textInputAction: TextInputAction.next,
                                    autofillHints: const [AutofillHints.organizationName],
                                    enabled: !isLoading,
                                    decoration: const InputDecoration(
                                      labelText: 'Organization Name',
                                      prefixIcon: Icon(Icons.business_outlined),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.trim().isEmpty) {
                                        return 'Please enter your organization name';
                                      }
                                      return null;
                                    },
                                  ),
                                ],

                                // ── Password field (hidden in forgot-password mode) ──
                                if (_authMode != _AuthMode.forgotPassword) ...[
                                  const SizedBox(height: 20),
                                  PasswordTextFormField(
                                    controller: _passwordController,
                                    enabled: !isLoading,
                                    autofillHints: _authMode == _AuthMode.signUp
                                        ? const [AutofillHints.newPassword]
                                        : const [AutofillHints.password],
                                    validator: AuthValidators.validatePassword,
                                    onFieldSubmitted: (_) => _submitForm(),
                                  ),
                                ],

                                // ── Forgot Password link (sign-in mode only) ──
                                if (_authMode == _AuthMode.signIn) ...[
                                  const SizedBox(height: 4),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton(
                                      onPressed: isLoading
                                          ? null
                                          : () => _switchToMode(
                                              _AuthMode.forgotPassword,
                                            ),
                                      child: Text(
                                        'Forgot Password?',
                                        style: TextStyle(
                                          color: colorScheme.primary,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],

                                const SizedBox(height: 20),

                                // ── Submit button ──
                                AuthSubmitButton(
                                  label: _submitButtonLabel,
                                  isLoading: isLoading,
                                  onPressed: _submitForm,
                                ),
                                const SizedBox(height: 16),

                                // ── Toggle links ──
                                _buildToggleLinks(
                                  isLoading,
                                  colorScheme,
                                  theme,
                                ),
                              ],
                            ),
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
  // Toggle Links
  // ───────────────────────────────────────────────────────────────────────────

  Widget _buildToggleLinks(
    bool isLoading,
    ColorScheme colorScheme,
    ThemeData theme,
  ) {
    return switch (_authMode) {
      _AuthMode.signIn => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Don't have an account?", style: theme.textTheme.bodyMedium),
          TextButton(
            onPressed: isLoading ? null : () => _switchToMode(_AuthMode.signUp),
            child: Text(
              'Sign Up',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
      _AuthMode.signUp => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Already have an account?', style: theme.textTheme.bodyMedium),
          TextButton(
            onPressed: isLoading ? null : () => _switchToMode(_AuthMode.signIn),
            child: Text(
              'Sign In',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
      _AuthMode.forgotPassword => TextButton(
        onPressed: isLoading ? null : () => _switchToMode(_AuthMode.signIn),
        child: Text(
          'Back to Sign In',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: colorScheme.primary,
          ),
        ),
      ),
    };
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Listener — show snackbar on auth state changes
  // ───────────────────────────────────────────────────────────────────────────

  void _authStateListener(BuildContext context, AuthenticationState state) {
    handleAuthenticationStateForSnackbar(
      context,
      state,
      onPasswordResetEmailSent: () => _switchToMode(_AuthMode.signIn),
      onEmailConfirmationSent: () => _switchToMode(_AuthMode.signIn),
    );
  }
}
