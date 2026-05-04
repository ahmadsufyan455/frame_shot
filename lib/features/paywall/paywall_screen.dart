import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/router.dart';
import '../settings/providers/settings_providers.dart';

class PaywallScreen extends ConsumerWidget {
  const PaywallScreen({super.key, this.trigger});

  final PaywallTrigger? trigger;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final proAsync = ref.watch(proStatusProvider);
    final isLoading = proAsync.isLoading;

    return Scaffold(
      backgroundColor: Colors.black,
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF171717), Color(0xFF000000), Color(0xFF0A0A0A)],
            stops: [0, 0.5, 1],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: CustomScrollView(
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 8, 24, 48),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _BackButton(onPressed: () => Navigator.pop(context)),
                          const SizedBox(height: 24),
                          const _ProIcon(),
                          const SizedBox(height: 28),
                          const Text(
                            'FrameShot Pro',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.w700,
                              height: 1.2,
                              letterSpacing: 0,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Unlock the ultimate presentation for your '
                            'photography. One-time payment, yours forever.',
                            style: TextStyle(
                              color: Color(0xFFA1A1A1),
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              height: 1.62,
                              letterSpacing: 0,
                            ),
                          ),
                          const SizedBox(height: 32),
                          const _FeatureList(),
                          const Spacer(),
                          const SizedBox(height: 40),
                          const Divider(height: 1, color: Color(0x1AFFFFFF)),
                          const SizedBox(height: 24),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Lifetime Unlock',
                                style: TextStyle(
                                  color: Color(0xFFA1A1A1),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  height: 1.4,
                                  letterSpacing: 0,
                                ),
                              ),
                              Text(
                                'IDR 59.000',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  height: 1.33,
                                  letterSpacing: 0,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: FilledButton(
                              onPressed: isLoading
                                  ? null
                                  : () => ref
                                        .read(proStatusProvider.notifier)
                                        .purchase(),
                              style: FilledButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                disabledBackgroundColor: Colors.white
                                    .withValues(alpha: 0.7),
                                disabledForegroundColor: Colors.black54,
                                elevation: 0,
                                shadowColor: Colors.white.withValues(
                                  alpha: 0.35,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                textStyle: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  height: 1.5,
                                  letterSpacing: 0,
                                ),
                              ),
                              child: isLoading
                                  ? const SizedBox.square(
                                      dimension: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text('Unlock FrameShot Pro'),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Center(
                            child: Text(
                              'Secure one-time payment. No subscriptions.',
                              style: TextStyle(
                                color: Color(0xFF525252),
                                fontSize: 10,
                                fontWeight: FontWeight.w400,
                                height: 1.5,
                                letterSpacing: 0,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Center(
                            child: TextButton(
                              onPressed: isLoading
                                  ? null
                                  : () => ref
                                        .read(proStatusProvider.notifier)
                                        .restore(),
                              style: TextButton.styleFrom(
                                foregroundColor: const Color(0xFF737373),
                                minimumSize: Size.zero,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 6,
                                ),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                textStyle: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  height: 1.3,
                                  letterSpacing: 0,
                                ),
                              ),
                              child: const Text('Restore Purchase'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: const Icon(Icons.chevron_left, color: Colors.white, size: 28),
      style: IconButton.styleFrom(
        fixedSize: const Size.square(40),
        minimumSize: const Size.square(40),
        padding: EdgeInsets.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}

class _ProIcon extends StatelessWidget {
  const _ProIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Icon(
        Icons.auto_awesome_outlined,
        color: Colors.white,
        size: 34,
      ),
    );
  }
}

class _FeatureList extends StatelessWidget {
  const _FeatureList();

  static const _features = [
    'All 6+ premium frame styles',
    'Full resolution uncompressed export',
    'Remove all FrameShot watermarks',
    'Custom text, fonts & color themes',
    'Camera brand logos displayed',
    'Batch export up to 20 photos',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final feature in _features) ...[
          _FeatureRow(label: feature),
          if (feature != _features.last) const SizedBox(height: 16),
        ],
      ],
    );
  }
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 2),
          child: Icon(
            Icons.check_circle_outline,
            color: Color(0xFF00E676),
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: Color(0xFFE5E5E5),
              fontSize: 14,
              fontWeight: FontWeight.w400,
              height: 1.43,
              letterSpacing: 0,
            ),
          ),
        ),
      ],
    );
  }
}
