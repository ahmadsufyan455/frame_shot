import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/customize_providers.dart';

class LogoToggle extends ConsumerWidget {
  const LogoToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showLogo = ref.watch(
      frameConfigProvider
          .select((c) => c.showCameraLogo),
    );

    return SwitchListTile.adaptive(
      title: Text(
        'Camera Logo',
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      subtitle: const Text(
        'Show brand logo on frame',
      ),
      secondary: const Icon(Icons.camera_alt_outlined),
      value: showLogo,
      onChanged: (v) => ref
          .read(frameConfigProvider.notifier)
          .toggleCameraLogo(v),
      contentPadding: EdgeInsets.zero,
    );
  }
}
