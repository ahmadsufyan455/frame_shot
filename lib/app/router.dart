import 'package:go_router/go_router.dart';

import '../features/home/home_screen.dart';
import '../features/paywall/paywall_screen.dart';
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
    ),
    GoRoute(
      path: '/paywall',
      name: 'paywall',
      builder: (context, state) {
        final trigger =
            state.extra as PaywallTrigger?;
        return PaywallScreen(trigger: trigger);
      },
    ),
    GoRoute(
      path: '/settings',
      name: 'settings',
      builder: (context, state) =>
          const SettingsScreen(),
    ),
  ],
);


