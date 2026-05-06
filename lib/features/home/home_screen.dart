import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../app/router.dart';
import '../../core/constants/app_constants.dart';
import '../../core/models/frame_style.dart';
import '../../core/models/image_file.dart';
import '../customize/providers/customize_providers.dart';
import '../preview/providers/preview_providers.dart';
import '../preview/providers/style_providers.dart';
import '../settings/providers/settings_providers.dart';
import 'widgets/import_button.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _isLoading = false;

  Future<void> _showImportOptionsSheet() async {
    if (_isLoading) return;
    final isPro = ref.read(proStatusProvider).value ?? false;

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF171717),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 26),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 48,
                    height: 6,
                    decoration: BoxDecoration(
                      color: const Color(0xFF575757),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                const SizedBox(height: 34),
                const Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Text(
                    'Import Photos',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      height: 1.25,
                      letterSpacing: 0,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _ImportOptionTile(
                  icon: Icons.add_photo_alternate_outlined,
                  title: 'Single Photo',
                  subtitle: 'Frame one perfect shot',
                  backgroundColor: Color(0xFF333333),
                  iconBackgroundColor: Color(0xFF5A5A5A),
                  iconColor: Colors.white,
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    _pickImage();
                  },
                ),
                const SizedBox(height: 10),
                _ImportOptionTile(
                  icon: Icons.photo_library_outlined,
                  title: 'Batch Process',
                  subtitle: 'Apply to multiple photos',
                  backgroundColor: Color(0xFF242424),
                  iconBackgroundColor: Color(0xFF151515),
                  iconColor: Colors.white,
                  isLocked: !isPro,
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    _pickBatchImages();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickImage() async {
    setState(() {
      _isLoading = true;
    });

    final picker = ImagePicker();
    final xFile = await picker.pickImage(source: ImageSource.gallery);

    if (xFile == null) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      return;
    }

    final file = File(xFile.path);
    final stat = await file.stat();

    ref.read(selectedBatchImagesProvider.notifier).clear();

    ref
        .read(selectedImageProvider.notifier)
        .set(
          ImageFile(path: xFile.path, name: xFile.name, sizeBytes: stat.size),
        );

    // Reset style and config to defaults for each new import.
    await ref
        .read(settingsProvider.notifier)
        .setLastStyleId(FrameStyleId.classic);
    ref.invalidate(selectedStyleProvider);
    ref.invalidate(frameConfigProvider);

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      await context.pushNamed('preview');
    }
  }

  Future<void> _pickBatchImages() async {
    final isPro = ref.read(proStatusProvider).value ?? false;
    if (!isPro) {
      if (mounted) {
        await context.pushNamed('paywall', extra: PaywallTrigger.export);
      }
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final picker = ImagePicker();
    final xFiles = await picker.pickMultiImage(limit: AppLimits.maxBatchExport);

    if (xFiles.isEmpty) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      return;
    }

    final images = <ImageFile>[];
    for (final xFile in xFiles) {
      final file = File(xFile.path);
      final stat = await file.stat();
      images.add(
        ImageFile(path: xFile.path, name: xFile.name, sizeBytes: stat.size),
      );
    }

    ref.read(selectedBatchImagesProvider.notifier).set(images);
    ref.read(selectedImageProvider.notifier).set(images.first);

    await ref
        .read(settingsProvider.notifier)
        .setLastStyleId(FrameStyleId.classic);
    ref.invalidate(selectedStyleProvider);
    ref.invalidate(frameConfigProvider);

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      await context.pushNamed('preview');
    }
  }

  @override
  Widget build(BuildContext context) {
    const double largeScreenMinWidth = 600.0;

    return Scaffold(
      backgroundColor: Colors.black,
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > largeScreenMinWidth) {
            return _buildLargeScreenLayout();
          } else {
            return _buildSmallScreenLayout();
          }
        },
      ),
    );
  }

  Widget _buildTopRightActions() {
    return SafeArea(
      child: Align(
        alignment: Alignment.topRight,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: IconButton(
            icon: const Icon(
              Icons.settings_outlined,
              color: Colors.white,
              size: 28,
            ),
            onPressed: () => context.pushNamed('settings'),
          ),
        ),
      ),
    );
  }

  Widget _buildTextContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Color(0x66000000),
                blurRadius: 24,
                offset: Offset(0, 12),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Image.asset(
            'assets/icons/frame_shot_icon.png',
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'FrameShot',
          style: TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Your shot. Your gear. Your story.',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildLargeScreenLayout() {
    return Stack(
      children: [
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTextContent(),
              const SizedBox(width: 100),
              ImportButton(
                onTap: _showImportOptionsSheet,
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
        _buildTopRightActions(),
      ],
    );
  }

  Widget _buildSmallScreenLayout() {
    return Stack(
      children: [
        Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTextContent(),
                const SizedBox(height: 64),
                ImportButton(
                  onTap: _showImportOptionsSheet,
                  isLoading: _isLoading,
                ),
              ],
            ),
          ),
        ),
        _buildTopRightActions(),
      ],
    );
  }
}

class _ImportOptionTile extends StatelessWidget {
  const _ImportOptionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.backgroundColor,
    required this.iconBackgroundColor,
    required this.iconColor,
    required this.onTap,
    this.isLocked = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color backgroundColor;
  final Color iconBackgroundColor;
  final Color iconColor;
  final VoidCallback onTap;
  final bool isLocked;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Ink(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(14),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconBackgroundColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            height: 1.25,
                            letterSpacing: 0,
                          ),
                        ),
                      ),
                      if (isLocked) ...[
                        const SizedBox(width: 12),
                        const Icon(
                          Icons.lock_outline,
                          color: Color(0xFFA1A1A1),
                          size: 18,
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Color(0xFFA1A1A1),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      height: 1.25,
                      letterSpacing: 0,
                    ),
                  ),
                ],
              ),
            ),
            if (isLocked) ...[
              const SizedBox(width: 12),
              const _ProPill(),
            ],
          ],
        ),
      ),
    );
  }
}

class _ProPill extends StatelessWidget {
  const _ProPill();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF272248),
        border: Border.all(color: const Color(0xFF4F46E5)),
        borderRadius: BorderRadius.circular(999),
      ),
      child: const Text(
        'PRO',
        style: TextStyle(
          color: Color(0xFF8EA0FF),
          fontSize: 13,
          fontWeight: FontWeight.w800,
          height: 1,
          letterSpacing: 2,
        ),
      ),
    );
  }
}
