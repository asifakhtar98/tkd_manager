import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/di/injection.dart';
import '../../domain/entities/activation_request_entity.dart';
import '../bloc/admin_activation_bloc.dart';
import '../bloc/admin_activation_event.dart';
import '../bloc/admin_activation_state.dart';

/// Admin panel for reviewing and acting on pending activation requests.
///
/// Displays a data table of all pending requests with Approve / Reject
/// action buttons. Each button shows an inline spinner while processing.
class AdminActivationScreen extends StatelessWidget {
  const AdminActivationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<AdminActivationBloc>()
            ..add(const AdminActivationEvent.loadPendingRequests()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Admin — Activation Requests'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/');
              }
            },
          ),
        ),
        body: const SafeArea(child: _AdminActivationContent()),
      ),
    );
  }
}

class _AdminActivationContent extends StatelessWidget {
  const _AdminActivationContent();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdminActivationBloc, AdminActivationState>(
      listenWhen: (previous, current) =>
          previous.successMessage != current.successMessage ||
          previous.error != current.error,
      listener: (context, state) {
        if (state.successMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.successMessage!),
              backgroundColor: Colors.green.shade700,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
        if (state.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error!.message),
              backgroundColor: Theme.of(context).colorScheme.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.pendingRequests.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check_circle_outline,
                  size: 64,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  'No pending activation requests.',
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 24),
                OutlinedButton.icon(
                  icon: const Icon(Icons.refresh),
                  label: const Text('Refresh'),
                  onPressed: () => context.read<AdminActivationBloc>().add(
                    const AdminActivationEvent.loadPendingRequests(),
                  ),
                ),
              ],
            ),
          );
        }

        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Pending Requests (${state.pendingRequests.length})',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      OutlinedButton.icon(
                        icon: const Icon(Icons.refresh, size: 18),
                        label: const Text('Refresh'),
                        onPressed: () =>
                            context.read<AdminActivationBloc>().add(
                              const AdminActivationEvent.loadPendingRequests(),
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ...state.pendingRequests.map(
                    (request) => _ActivationRequestCard(
                      request: request,
                      isProcessing: state.processingRequestIds.contains(
                        request.id,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// A card displaying a single pending activation request with
/// approve/reject actions.
class _ActivationRequestCard extends StatelessWidget {
  const _ActivationRequestCard({
    required this.request,
    required this.isProcessing,
  });

  final ActivationRequestEntity request;
  final bool isProcessing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('dd MMM yyyy, hh:mm a');

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row: contact name + date
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.person_outline,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        request.contactName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Submitted ${dateFormat.format(request.createdAt.toLocal())}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                Chip(
                  label: Text(
                    '${request.requestedDays} ${request.requestedDays == 1 ? 'day' : 'days'}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  backgroundColor: theme.colorScheme.primaryContainer,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Amount and user ID info
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  _InfoColumn(
                    label: 'Amount',
                    value: '₹${request.totalAmount}',
                  ),
                  const SizedBox(width: 32),
                  Expanded(
                    child: _InfoColumn(
                      label: 'User ID',
                      value: request.userId.substring(0, 8),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton.icon(
                  icon: isProcessing
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Icon(Icons.close, color: Colors.red.shade700),
                  label: Text(
                    'Reject',
                    style: TextStyle(color: Colors.red.shade700),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.red.shade200),
                  ),
                  onPressed: isProcessing
                      ? null
                      : () => _confirmReject(context, request.id),
                ),
                const SizedBox(width: 12),
                FilledButton.icon(
                  icon: isProcessing
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.check),
                  label: Text('Approve (+${request.requestedDays} days)'),
                  onPressed: isProcessing
                      ? null
                      : () => context.read<AdminActivationBloc>().add(
                          AdminActivationEvent.approveRequest(request),
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmReject(BuildContext context, String requestId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Reject Request?'),
        content: const Text(
          'This will reject the activation request. The user will need to submit a new request.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade700,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Reject'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      context.read<AdminActivationBloc>().add(
        AdminActivationEvent.rejectRequest(requestId),
      );
    }
  }
}

class _InfoColumn extends StatelessWidget {
  const _InfoColumn({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
      ],
    );
  }
}
