import 'package:flutter/material.dart';

/// Reusable circular-icon + title branding header used on auth screens
/// (login, password reset, etc.).
///
/// Accepts a customisable [icon] and [title] so each screen can brand
/// itself without duplicating the layout code.
class AuthBrandingHeader extends StatelessWidget {
  const AuthBrandingHeader({
    super.key,
    this.icon,
    required this.title,
    this.imagePath,
  });

  /// The icon shown inside the circular container.
  final IconData? icon;

  /// Optional image asset path to show instead of an icon.
  final String? imagePath;

  /// The large heading displayed below the icon.
  final String title;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (imagePath != null)
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(imagePath!, width: 80, height: 80),
          )
        else if (icon != null)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 48, color: colorScheme.onPrimaryContainer),
          ),
        const SizedBox(height: 16),
        Text(
          title,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.primary,
          ),
        ),
      ],
    );
  }
}
