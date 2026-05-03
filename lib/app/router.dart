import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/home/home_screen.dart';
import '../features/preview/preview_screen.dart';
import '../features/settings/settings_screen.dart';

enum PaywallTrigger { style, customize, export }

final goRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) =>
          const HomeScreen(),
    ),
    GoRoute(
      path: '/preview',
      name: 'preview',
      builder: (context, state) =>
          const PreviewScreen(),
      routes: [
        GoRoute(
          path: 'export',
          name: 'export',
          builder: (context, state) =>
              const _Placeholder(label: 'Export'),
        ),
      ],
    ),
    GoRoute(
      path: '/paywall',
      name: 'paywall',
      builder: (context, state) =>
          const _Placeholder(label: 'Paywall'),
    ),
    GoRoute(
      path: '/settings',
      name: 'settings',
      builder: (context, state) =>
          const SettingsScreen(),
    ),
  ],
);

class _Placeholder extends StatelessWidget {
  const _Placeholder({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(label)),
      body: Center(child: Text(label)),
    );
  }
}
