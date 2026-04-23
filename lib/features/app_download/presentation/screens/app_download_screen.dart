import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:tkd_saas/core/config/app_config.dart';
import 'package:tkd_saas/core/router/app_routes.dart';

/// A public-facing "Download the App" screen served at the `/app` route.
///
/// This page is accessible **without authentication** and is the default
/// landing destination for mobile users who arrive via a shared web link.
///
/// On web it also shows a "Continue on web instead" link that navigates
/// to the main application (login or dashboard depending on auth state).
class AppDownloadScreen extends StatelessWidget {
  const AppDownloadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isNarrowViewport = MediaQuery.sizeOf(context).width < 600;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
              theme.colorScheme.surface,
              theme.colorScheme.tertiaryContainer.withValues(alpha: 0.2),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ── App branding ──
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: theme.colorScheme.primary.withValues(alpha: 0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.emoji_events_rounded,
                      size: 44,
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),

                  const SizedBox(height: 24),

                  Text(
                    'GameCon',
                    style: theme.textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Tournament brackets, simplified',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),

                  const SizedBox(height: 48),

                  // ── Download card ──
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 480),
                    child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: theme.colorScheme.outlineVariant,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          children: [
                            Icon(
                              Icons.smartphone_rounded,
                              size: 48,
                              color: theme.colorScheme.primary,
                            ),

                            const SizedBox(height: 16),

                            Text(
                              'Get the mobile app',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            const SizedBox(height: 12),

                            Text(
                              'Download GameCon on your phone for the best '
                              'experience — optimised for touch, offline-ready, '
                              'and always up to date.',
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),

                            const SizedBox(height: 28),

                            // ── Store badges ──
                            isNarrowViewport
                                ? Column(
                                    children: [
                                      _StoreBadgeButton(
                                        label: 'App Store',
                                        subtitle: 'Download on the',
                                        icon: Icons.apple_rounded,
                                        url: AppConfig.appStoreUrl,
                                      ),
                                      const SizedBox(height: 12),
                                      _StoreBadgeButton(
                                        label: 'Google Play',
                                        subtitle: 'Get it on',
                                        icon: Icons.shop_rounded,
                                        url: AppConfig.playStoreUrl,
                                      ),
                                    ],
                                  )
                                : Row(
                                    children: [
                                      Expanded(
                                        child: _StoreBadgeButton(
                                          label: 'App Store',
                                          subtitle: 'Download on the',
                                          icon: Icons.apple_rounded,
                                          url: AppConfig.appStoreUrl,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: _StoreBadgeButton(
                                          label: 'Google Play',
                                          subtitle: 'Get it on',
                                          icon: Icons.shop_rounded,
                                          url: AppConfig.playStoreUrl,
                                        ),
                                      ),
                                    ],
                                  ),

                            const SizedBox(height: 20),

                            // ── "Continue on Web" link (web only) ──
                            if (kIsWeb)
                              TextButton.icon(
                                onPressed: () =>
                                    const DashboardRoute().go(context),
                                icon: const Icon(Icons.language_rounded),
                                label: const Text('Continue on web instead'),
                              ),
                          ],
                        ),
                      ),
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

/// A styled button that resembles an app-store download badge.
class _StoreBadgeButton extends StatelessWidget {
  const _StoreBadgeButton({
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.url,
  });

  final String label;
  final String subtitle;
  final IconData icon;
  final String url;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Material(
      color: theme.colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => launchUrl(Uri.parse(url)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 28),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subtitle,
                    style: theme.textTheme.labelSmall,
                  ),
                  Text(
                    label,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
