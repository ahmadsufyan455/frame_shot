import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'theme.dart';

class FrameShotApp extends ConsumerWidget {
  const FrameShotApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO(router): Replace with MaterialApp.router (TASK-075).
    return MaterialApp(
      title: 'FrameShot',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      home: const Scaffold(
        body: Center(
          child: Text('FrameShot'),
        ),
      ),
    );
  }
}
