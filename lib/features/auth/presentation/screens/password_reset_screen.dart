import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tkd_saas/core/config/app_config.dart';
import 'package:tkd_saas/features/auth/presentation/bloc/authentication_bloc.dart';
import 'package:tkd_saas/features/auth/presentation/utils/auth_snackbar_listener.dart';
import 'package:tkd_saas/features/auth/presentation/utils/auth_validators.dart';
import 'package:tkd_saas/features/auth/presentation/widgets/auth_branding_header.dart';
import 'package:tkd_saas/features/auth/presentation/widgets/auth_submit_button.dart';
import 'package:tkd_saas/features/auth/presentation/widgets/password_text_form_field.dart';

/// Screen shown after the user clicks a password-recovery link from their
/// email. Supabase has already established a recovery session; the user
/// simply enters a new password here.
class PasswordResetScreen extends StatefulWidget {
  const PasswordResetScreen({super.key});

  @override
  State<PasswordResetScreen> createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends State<PasswordResetScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Actions
  // ───────────────────────────────────────────────────────────────────────────

  void _submitNewPassword() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    context.read<AuthenticationBloc>().add(
      AuthenticationPasswordUpdateRequested(
        newPassword: _passwordController.text,
      ),
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Build
  // ───────────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(AppConfig.authBackgroundImage),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
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
                        icon: Icons.lock_reset,
                        title: 'Reset Your Password',
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
                                    'Set New Password',
                                    style: theme.textTheme.headlineSmall
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: colorScheme.onSurface,
                                        ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Enter your new password below',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 32),

                                  // ── New Password ──
                                  PasswordTextFormField(
                                    controller: _passwordController,
                                    labelText: 'New Password',
                                    textInputAction: TextInputAction.next,
                                    autofillHints: const [
                                      AutofillHints.newPassword,
                                    ],
                                    enabled: !isLoading,
                                    validator: AuthValidators.validatePassword,
                                  ),
                                  const SizedBox(height: 20),

                                  // ── Confirm Password ──
                                  PasswordTextFormField(
                                    controller: _confirmPasswordController,
                                    labelText: 'Confirm Password',
                                    prefixIcon: Icons.lock_reset_outlined,
                                    enabled: !isLoading,
                                    validator:
                                        AuthValidators.validateConfirmPassword(
                                          _passwordController,
                                        ),
                                    onFieldSubmitted: (_) =>
                                        _submitNewPassword(),
                                  ),
                                  const SizedBox(height: 28),

                                  // ── Submit button ──
                                  AuthSubmitButton(
                                    label: 'Update Password',
                                    isLoading: isLoading,
                                    onPressed: _submitNewPassword,
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
      ),
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Listener
  // ───────────────────────────────────────────────────────────────────────────

  void _authStateListener(BuildContext context, AuthenticationState state) {
    handleAuthenticationStateForSnackbar(context, state);
  }
}
