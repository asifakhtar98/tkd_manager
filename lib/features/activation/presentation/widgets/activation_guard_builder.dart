import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tkd_saas/features/activation/domain/entities/activation_status.dart';
import 'package:tkd_saas/features/activation/presentation/bloc/activation_status_bloc.dart';
import 'package:tkd_saas/features/activation/presentation/bloc/activation_status_state.dart';

/// A utility widget that provides a boolean `isLocked` to its builder based on
/// the global [ActivationStatusBloc] state.
///
/// Features are considered locked if the user is NOT an admin AND their
/// subscription state is NOT [ActivationStatusActive].
class ActivationGuardBuilder extends StatelessWidget {
  const ActivationGuardBuilder({super.key, required this.builder});

  /// Builder providing the locked configuration context for the widget to render.
  final Widget Function(BuildContext context, bool isLocked) builder;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActivationStatusBloc, ActivationStatusState>(
      builder: (context, state) {
        // Feature is unlocked if either: user is an Admin, OR user has an active subscription.
        final bool isUnlocked =
            state.isAdmin || state.activationStatus is ActivationStatusActive;

        // Feature is locked if not unlocked
        final bool isLocked = !isUnlocked;

        return builder(context, isLocked);
      },
    );
  }
}
