import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/router.dart';
import '../settings/providers/settings_providers.dart';
import 'widgets/comparison_card.dart';

class PaywallScreen extends ConsumerWidget {
  const PaywallScreen({super.key, this.trigger});

  final PaywallTrigger? trigger;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final proAsync = ref.watch(proStatusProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Go Pro')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Column(
            children: [
              const SizedBox(height: 16),
              Icon(
                Icons.auto_awesome,
                size: 48,
                color: colorScheme.primary,
              ),
              const SizedBox(height: 12),
              Text(
                'Unlock FrameShot Pro',
                style: textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'One-time purchase. Lifetime access.',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.outline,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              const Expanded(
                child: SingleChildScrollView(
                  child: ComparisonCard(),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: proAsync.isLoading
                      ? null
                      : () => ref
                            .read(
                              proStatusProvider
                                  .notifier,
                            )
                            .purchase(),
                  child: proAsync.isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child:
                              CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Unlock Pro — IDR 59,000',
                        ),
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: proAsync.isLoading
                    ? null
                    : () => ref
                          .read(
                            proStatusProvider.notifier,
                          )
                          .restore(),
                child: const Text('Restore Purchase'),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
