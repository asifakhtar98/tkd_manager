import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tkd_saas/core/di/injection.dart';
import 'package:tkd_saas/features/auth/presentation/bloc/authentication_bloc.dart';
import 'package:tkd_saas/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:tkd_saas/features/profile/presentation/widgets/change_password_dialog.dart';
import 'package:tkd_saas/features/tournament/presentation/bloc/tournament_bloc.dart';
import 'package:tkd_saas/features/activation/presentation/bloc/activation_status_bloc.dart';
import 'package:tkd_saas/features/activation/presentation/bloc/activation_status_state.dart';
import 'package:tkd_saas/features/activation/domain/entities/activation_status.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ProfileBloc>(),
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Profile')),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          state.whenOrNull(
            updateFailure: (message) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(message), backgroundColor: Colors.red),
              );
            },
            updateSuccess: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Profile updated successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            },
          );
        },
        builder: (context, state) {
          // Wrap content in a loading overlay if updating
          return Stack(
            children: [
              _buildContent(context),
              if (state is ProfileUpdateInProgress)
                const ColoredBox(
                  color: Colors.black26,
                  child: Center(child: CircularProgressIndicator()),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 600,
          ), // Card constraints for desktop
          child: Column(
            crossAxisAlignment: crossAxisAlignment,
            children: [
              _IdentityCard(),
              const SizedBox(height: 24),
              _AccountActionsCard(),
              const SizedBox(height: 24),
              _SoftwareStatusCard(),
              const SizedBox(height: 24),
              _DangerZoneCard(),
            ],
          ),
        ),
      ),
    );
  }

  CrossAxisAlignment get crossAxisAlignment => CrossAxisAlignment.stretch;
}

class _IdentityCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        final user = state.whenOrNull(authenticated: (user) => user);
        if (user == null) return const SizedBox.shrink();

        final orgName =
            user.userMetadata?['display_name'] as String? ?? 'N/A';
        final initial = orgName.isNotEmpty ? orgName[0].toUpperCase() : 'A';

        return Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.grey.shade300),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 36,
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.primaryContainer,
                  foregroundColor: Theme.of(
                    context,
                  ).colorScheme.onPrimaryContainer,
                  child: Text(
                    initial,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        orgName,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user.email ?? 'No email associated',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'ID: ${user.id}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey.shade500,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                ),
                // Only show Edit if there's an organization string editable
                IconButton(
                  onPressed: () {
                    
                    _showEditOrganizationDialog(context, orgName);
                  },
                  icon: const Icon(Icons.edit_outlined),
                  tooltip: 'Edit Profile',
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showEditOrganizationDialog(BuildContext context, String currentName) {
    final controller = TextEditingController(text: currentName);

    showDialog(
      context: context,
      builder: (dContext) => AlertDialog(
        title: const Text('Edit Organization'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Organization Name',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final newName = controller.text.trim();
              if (newName != currentName) {
                // Pass event to BLoC
                context.read<ProfileBloc>().add(
                  ProfileUpdateOrganizationRequested(
                    newOrganizationName: newName,
                  ),
                );
              }
              Navigator.pop(dContext);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

class _AccountActionsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.lock_outline),
              title: const Text('Change Password'),
              subtitle: const Text('Update your login password'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => const ChangePasswordDialog(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SoftwareStatusCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Software Status',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            BlocBuilder<ActivationStatusBloc, ActivationStatusState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return const Text('Loading status...');
                }

                final activationStatus = state.activationStatus;

                if (activationStatus is ActivationStatusActive) {
                  final expiresAt = activationStatus.expiresAt;
                  final dateFormat = DateFormat('dd MMM yyyy');
                  final difference = expiresAt.difference(DateTime.now().toUtc());
                  final daysRemaining = difference.isNegative
                      ? 0
                      : (difference.inMinutes / 1440).ceil();

                  return _StatusRow(
                    icon: Icons.check_circle,
                    color: Colors.green,
                    title: 'Product Activated',
                    subtitle: 'Active until ${dateFormat.format(expiresAt.toLocal())} ($daysRemaining days remaining)',
                  );
                } else if (activationStatus == null ||
                    activationStatus is ActivationStatusNotActivated) {
                  return const _StatusRow(
                    icon: Icons.lock,
                    color: Colors.red,
                    title: 'Software Not Activated',
                    subtitle: 'Activate your software to unlock all features.',
                  );
                } else {
                  return const _StatusRow(
                    icon: Icons.warning_amber_rounded,
                    color: Colors.orange,
                    title: 'Activation Request Pending',
                    subtitle: 'Your activation request is awaiting admin approval.',
                  );
                }
              },
            ),
            const Divider(height: 32),
            BlocBuilder<TournamentBloc, TournamentState>(
              builder: (context, state) {
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total Tournaments Hosted'),
                        Text(
                          '${state.tournaments.length}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    /* 
                     * Extra stats could be added here, e.g.
                     * Total Brackets Generated, etc.
                     */
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;

  const _StatusRow({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DangerZoneCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.red.shade50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.red.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Danger Zone',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.red.shade900,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  context.read<AuthenticationBloc>().add(
                    const AuthenticationSignOutRequested(),
                  );
                  // No need to redirect manually; the AuthenticationBloc's status stream listener
                  // inside the app handles kicking the user back to the login screen.
                },
                icon: const Icon(Icons.logout),
                label: const Text('Sign Out'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
