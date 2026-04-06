import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_routes.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(RoutePaths.dashboard);
            }
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome, Admin',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Manage the system parameters and user requests.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 32),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  _DashboardCard(
                    title: 'Activation Requests',
                    description: 'Review and approve pending user software activations.',
                    icon: Icons.key_rounded,
                    color: Colors.blue.shade700,
                    onTap: () {
                      context.go('${RoutePaths.admin}/activations');
                    },
                  ),
                  // Add more admin tools here in the future
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  const _DashboardCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 300,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(
                color: Colors.grey.shade600,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text(
                  'Manage',
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(Icons.arrow_forward, color: color, size: 16),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
