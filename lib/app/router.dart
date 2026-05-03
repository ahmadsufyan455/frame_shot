import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum PaywallTrigger { style, customize, export }

final goRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const _Placeholder(
        label: 'Home',
      ),
    ),
    GoRoute(
      path: '/preview',
      name: 'preview',
      builder: (context, state) => const _Placeholder(
        label: 'Preview',
      ),
      routes: [
        GoRoute(
          path: 'export',
          name: 'export',
          builder: (context, state) => const _Placeholder(
            label: 'Export',
          ),
        ),
      ],
    ),
    GoRoute(
      path: '/paywall',
      name: 'paywall',
      builder: (context, state) {
        return const _Placeholder(label: 'Paywall');
      },
    ),
    GoRoute(
      path: '/settings',
      name: 'settings',
      builder: (context, state) => const _Placeholder(
        label: 'Settings',
      ),
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
