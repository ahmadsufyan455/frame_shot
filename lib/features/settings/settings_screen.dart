import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers/settings_providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final proAsync = ref.watch(proStatusProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Show location'),
            subtitle: const Text(
              'Display reverse-geocoded location '
              'from photo EXIF',
            ),
            value: settings.locationEnabled,
            onChanged: (value) => ref
                .read(settingsProvider.notifier)
                .setLocationEnabled(value),
          ),
          const Divider(),
          ListTile(
            title: const Text('Restore purchases'),
            subtitle: proAsync.when(
              data: (isPro) => Text(
                isPro ? 'Pro active' : 'Free tier',
              ),
              loading: () =>
                  const Text('Checking...'),
              error: (_, _) =>
                  const Text('Error checking'),
            ),
            trailing:
                const Icon(Icons.refresh_outlined),
            onTap: () => ref
                .read(proStatusProvider.notifier)
                .restore(),
          ),
          const Divider(),
          const ListTile(
            title: Text('About FrameShot'),
            subtitle: Text('v0.1.0'),
          ),
          const ListTile(
            title: Text('Privacy Policy'),
          ),
          const ListTile(
            title: Text('Terms of Service'),
          ),
        ],
      ),
    );
  }
}
