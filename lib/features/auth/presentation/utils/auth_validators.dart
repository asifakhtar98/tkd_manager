import 'package:flutter/widgets.dart' show TextEditingController;

/// Centralised form validators for authentication screens.
///
/// All methods are static and return a nullable [String] compatible with
/// [TextFormField.validator].
abstract final class AuthValidators {
  /// Validates that [value] is a non-empty, structurally valid email address.
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required.';
    }
    final RegExp emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Enter a valid email address.';
    }
    return null;
  }

  /// Validates that [value] is a non-empty password with at least 6 characters.
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required.';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters.';
    }
    return null;
  }

  /// Validates that [value] matches the current text in [passwordController].
  ///
  /// Accepts a [TextEditingController] instead of a raw [String] so that
  /// the comparison reads the **live** password value at validation time,
  /// not a stale snapshot captured at widget build time.
  static String? Function(String?) validateConfirmPassword(
    TextEditingController passwordController,
  ) {
    return (String? value) {
      if (value == null || value.isEmpty) {
        return 'Please confirm your password.';
      }
      if (value != passwordController.text) {
        return 'Passwords do not match.';
      }
      return null;
    };
  }
}
