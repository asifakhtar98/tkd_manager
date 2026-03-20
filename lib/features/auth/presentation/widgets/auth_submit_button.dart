import 'package:flutter/material.dart';

/// Full-width [FilledButton] with a built-in loading spinner.
///
/// Used on every auth form (login, sign-up, forgot-password, reset-password)
/// to eliminate identical button + spinner boilerplate.
class AuthSubmitButton extends StatelessWidget {
  const AuthSubmitButton({
    super.key,
    required this.label,
    required this.isLoading,
    required this.onPressed,
  });

  /// Button label shown when not loading.
  final String label;

  /// When `true`, the button is disabled and shows a [CircularProgressIndicator].
  final bool isLoading;

  /// Callback invoked on tap. Receives `null` when [isLoading] is `true`.
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: FilledButton(
        onPressed: isLoading ? null : onPressed,
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
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}
