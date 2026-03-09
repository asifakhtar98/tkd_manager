import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'core/router/app_router.dart';

void main() {
  runApp(const BracketGeneratorApp());
}

class BracketGeneratorApp extends StatefulWidget {
  const BracketGeneratorApp({super.key});

  @override
  State<BracketGeneratorApp> createState() => _BracketGeneratorAppState();
}

class _BracketGeneratorAppState extends State<BracketGeneratorApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = AppRouter.createRouter();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'TKD Tournament Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}
