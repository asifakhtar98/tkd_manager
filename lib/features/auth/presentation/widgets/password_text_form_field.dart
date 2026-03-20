import 'package:flutter/material.dart';

/// Self-contained password [TextFormField] with a built-in visibility toggle.
///
/// Encapsulates the visibility icon state internally so consumers don't need
/// to manage a `_isPasswordVisible` boolean themselves.
class PasswordTextFormField extends StatefulWidget {
  const PasswordTextFormField({
    super.key,
    required this.controller,
    this.labelText = 'Password',
    this.prefixIcon = Icons.lock_outline,
    this.enabled = true,
    this.validator,
    this.autofillHints = const [AutofillHints.password],
    this.textInputAction = TextInputAction.done,
    this.onFieldSubmitted,
  });

  /// Controller bound to the underlying [TextFormField].
  final TextEditingController controller;

  /// Label displayed inside the input decoration.
  final String labelText;

  /// Icon shown before the text input.
  final IconData prefixIcon;

  /// Whether the field accepts input.
  final bool enabled;

  /// Validation callback passed to [TextFormField.validator].
  final FormFieldValidator<String>? validator;

  /// Autofill hints passed to the underlying field (e.g. `newPassword`).
  final Iterable<String> autofillHints;

  /// Keyboard action button type.
  final TextInputAction textInputAction;

  /// Callback when the user submits the field via keyboard.
  final ValueChanged<String>? onFieldSubmitted;

  @override
  State<PasswordTextFormField> createState() => _PasswordTextFormFieldState();
}

class _PasswordTextFormFieldState extends State<PasswordTextFormField> {
  bool _isObscured = true;

  void _toggleVisibility() {
    setState(() => _isObscured = !_isObscured);
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _isObscured,
      textInputAction: widget.textInputAction,
      autofillHints: widget.autofillHints,
      enabled: widget.enabled,
      decoration: InputDecoration(
        labelText: widget.labelText,
        prefixIcon: Icon(widget.prefixIcon),
        suffixIcon: IconButton(
          icon: Icon(_isObscured ? Icons.visibility : Icons.visibility_off),
          onPressed: _toggleVisibility,
        ),
      ),
      validator: widget.validator,
      onFieldSubmitted: widget.onFieldSubmitted,
    );
  }
}
