import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class GlobalSupportFAB extends StatefulWidget {
  final GoRouter router;
  const GlobalSupportFAB({super.key, required this.router});

  @override
  State<GlobalSupportFAB> createState() => _GlobalSupportFABState();
}

class _GlobalSupportFABState extends State<GlobalSupportFAB> {
  late String _currentLocation;

  @override
  void initState() {
    super.initState();
    _currentLocation = _getLocation();
    widget.router.routerDelegate.addListener(_routeChanged);
  }

  @override
  void dispose() {
    widget.router.routerDelegate.removeListener(_routeChanged);
    super.dispose();
  }

  String _getLocation() {
    return widget.router.routerDelegate.currentConfiguration.uri.path;
  }

  void _routeChanged() {
    final location = _getLocation();
    if (_currentLocation != location) {
      setState(() {
        _currentLocation = location;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_currentLocation == '/' || _currentLocation == '/login') {
      return FloatingActionButton(
        onPressed: () {
          final navContext = widget.router.routerDelegate.navigatorKey.currentContext;
          if (navContext != null) {
            SupportModalSheet.show(navContext);
          }
        },
        child: const Icon(Icons.wechat_sharp),
      );
    }
    return const SizedBox.shrink();
  }
}

class SupportModalSheet extends StatelessWidget {
  static const String supportPhoneNumber = '+918473997673';
  
  const SupportModalSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'WhatsApp Customer Support',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const SelectableText(
                  supportPhoneNumber,
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.copy, size: 20),
                  tooltip: 'Copy Number',
                  onPressed: () {
                    Clipboard.setData(const ClipboardData(text: supportPhoneNumber));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Number copied to clipboard')),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.open_in_new, size: 20),
                  tooltip: 'Open in WhatsApp',
                  onPressed: () async {
                    final uri = Uri.parse('https://wa.me/${supportPhoneNumber.replaceAll('+', '')}');
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri, mode: LaunchMode.externalApplication);
                    } else {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Could not open WhatsApp')),
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      constraints: BoxConstraints(
        minWidth: MediaQuery.of(context).size.width * 0.8,
        maxWidth: MediaQuery.of(context).size.width * 0.8,
      ),
      builder: (context) => const SupportModalSheet(),
    );
  }
}
