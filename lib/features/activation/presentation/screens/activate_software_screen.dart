import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/injection.dart';
import '../bloc/activation_bloc.dart';
import '../bloc/activation_event.dart';
import '../bloc/activation_state.dart';
import '../bloc/activation_status_bloc.dart';
import '../bloc/activation_status_event.dart';
import '../bloc/activation_status_state.dart';
import '../../domain/entities/activation_status.dart';
import 'package:extended_image/extended_image.dart';

class ActivateSoftwareScreen extends StatelessWidget {
  const ActivateSoftwareScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ActivationBloc>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Activate Software'),
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
        body: const SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(24.0),
            child: _ActivateSoftwareContent(),
          ),
        ),
      ),
    );
  }
}

class _ActivateSoftwareContent extends StatelessWidget {
  const _ActivateSoftwareContent();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActivationStatusBloc, ActivationStatusState>(
      builder: (context, state) {
        if (state.activationStatus is ActivationStatusPendingReview) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(48.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.hourglass_top, size: 64, color: Colors.amber),
                  SizedBox(height: 24),
                  Text(
                    'Verification Pending',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Your activation request has been successfully submitted and is currently awaiting administrator review. Please check back later.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ],
              ),
            ),
          );
        }

        if (state.activationStatus is ActivationStatusActive) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(48.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle, size: 64, color: Colors.green),
                  SizedBox(height: 24),
                  Text(
                    'Software Activated',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'You already have an active subscription for this software.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ],
              ),
            ),
          );
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 800) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(child: _QrCodeSection()),
                  const SizedBox(width: 48),
                  Expanded(flex: 2, child: const _ActivationFormSection()),
                ],
              );
            } else {
              return const Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _QrCodeSection(),
                  SizedBox(height: 32),
                  _ActivationFormSection(),
                ],
              );
            }
          },
        );
      },
    );
  }
}

class _QrCodeSection extends StatelessWidget {
  const _QrCodeSection();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Text(
              'Complete Payment',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Scan the QR code below using any UPI app to make the payment for the calculated amount.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 32),
            Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: ExtendedImage.network(
                  'https://lldlunqzkltclpfzpjxh.supabase.co/storage/v1/object/public/assets/sa_enterprise_qr_52463_.png',
                  fit: BoxFit.cover,
                  cache: true,
                  loadStateChanged: (ExtendedImageState state) {
                    switch (state.extendedImageLoadState) {
                      case LoadState.loading:
                        return const Center(child: CircularProgressIndicator());
                      case LoadState.completed:
                        return state.completedWidget;
                      case LoadState.failed:
                        return Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.error_outline,
                                size: 48,
                                color: Colors.grey.shade500,
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Failed to load QR',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        );
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'After taking the payment, please fill the details on the side to submit the activation request. Admins will verify the payment and activate your software.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActivationFormSection extends StatefulWidget {
  const _ActivationFormSection();

  @override
  State<_ActivationFormSection> createState() => _ActivationFormSectionState();
}

class _ActivationFormSectionState extends State<_ActivationFormSection> {
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocConsumer<ActivationBloc, ActivationState>(
      listenWhen: (prev, current) =>
          prev.isSuccess != current.isSuccess || prev.error != current.error,
      listener: (context, state) {
        if (state.isSuccess) {
          _nameController.clear();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Activation request submitted successfully. It is pending verification!',
              ),
            ),
          );
          context.read<ActivationStatusBloc>().add(
            const ActivationStatusEvent.loadRequested(),
          );
          context.go('/');
        } else if (state.error != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.error!.message)));
        }
      },
      builder: (context, state) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Activation Details',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),

                const SpacerOrSizedBox(),
                const Text(
                  'Select Activation Period',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    OutlinedButton.icon(
                      icon: const Icon(Icons.add),
                      label: const Text('1 Day'),
                      onPressed: () => context.read<ActivationBloc>().add(
                        const ActivationEvent.addDays(1),
                      ),
                    ),
                    OutlinedButton.icon(
                      icon: const Icon(Icons.add),
                      label: const Text('7 Days'),
                      onPressed: () => context.read<ActivationBloc>().add(
                        const ActivationEvent.addDays(7),
                      ),
                    ),
                    OutlinedButton.icon(
                      icon: const Icon(Icons.check_circle_outline),
                      label: const Text('15 Days (Save 15%)'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.blue.shade700,
                        side: BorderSide(color: Colors.blue.shade700),
                      ),
                      onPressed: () => context.read<ActivationBloc>().add(
                        const ActivationEvent.setDays(15),
                      ),
                    ),
                    OutlinedButton.icon(
                      icon: const Icon(Icons.check_circle_outline),
                      label: const Text('1 Month (Save 25%)'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.purple.shade700,
                        side: BorderSide(color: Colors.purple.shade700),
                      ),
                      onPressed: () => context.read<ActivationBloc>().add(
                        const ActivationEvent.setDays(30),
                      ),
                    ),
                    OutlinedButton.icon(
                      icon: const Icon(Icons.star),
                      label: const Text('1 Year (Save 50%)'),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.amber.shade50,
                        foregroundColor: Colors.amber.shade900,
                        side: BorderSide(
                          color: Colors.amber.shade700,
                          width: 2,
                        ),
                      ),
                      onPressed: () => context.read<ActivationBloc>().add(
                        const ActivationEvent.setDays(365),
                      ),
                    ),
                  ],
                ),

                if (state.requestedDays > 0) ...[
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      icon: const Icon(Icons.clear, size: 16),
                      label: const Text('Clear Selection'),
                      onPressed: () => context.read<ActivationBloc>().add(
                        const ActivationEvent.clearDays(),
                      ),
                    ),
                  ),
                ],

                const SpacerOrSizedBox(),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    children: [
                      _CostRow(
                        label: 'Requested Days',
                        value: '${state.requestedDays} days',
                      ),
                      const SizedBox(height: 8),
                      _CostRow(label: 'Base Rate', value: '₹800 / day'),
                      const Divider(),
                      _CostRow(
                        label: 'Subtotal',
                        value: '₹${state.requestedDays * 800}',
                      ),
                      if (state.discountAmount > 0) ...[
                        const SizedBox(height: 8),
                        _CostRow(
                          label: state.discountPercentage > 0
                              ? 'Bulk Discount (${state.discountPercentage}%)'
                              : 'Daily Discount (₹50/day)',
                          value: '- ₹${state.discountAmount}',
                          valueColor: Colors.green.shade700,
                        ),
                      ],
                      const Divider(),
                      _CostRow(
                        label: 'Total Amount Payable',
                        value: '₹${state.totalAmount}',
                        isTotal: true,
                        valueColor: theme.colorScheme.primary,
                      ),
                    ],
                  ),
                ),

                const SpacerOrSizedBox(),
                const Text(
                  'Contact Information',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Contact Person Name',
                    hintText: 'Enter your full name',
                    prefixIcon: Icon(Icons.person),
                  ),
                  onChanged: (val) {
                    context.read<ActivationBloc>().add(
                      ActivationEvent.contactNameChanged(val),
                    );
                  },
                ),

                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed:
                      state.isLoading ||
                          state.requestedDays == 0 ||
                          state.contactName.trim().isEmpty
                      ? null
                      : () {
                          context.read<ActivationBloc>().add(
                            const ActivationEvent.submitRequested(),
                          );
                        },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: state.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text('Submit Request for ₹${state.totalAmount}'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class SpacerOrSizedBox extends StatelessWidget {
  const SpacerOrSizedBox({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(height: 32);
  }
}

class _CostRow extends StatelessWidget {
  const _CostRow({
    required this.label,
    required this.value,
    this.isTotal = false,
    this.valueColor,
  });

  final String label;
  final String value;
  final bool isTotal;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            fontSize: isTotal ? 16 : 14,
            color: isTotal ? Colors.black : Colors.grey.shade700,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            fontSize: isTotal ? 18 : 14,
            color:
                valueColor ?? (isTotal ? Colors.black : Colors.grey.shade800),
          ),
        ),
      ],
    );
  }
}
