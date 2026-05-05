import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

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
              ImportButton(onTap: _pickImage, isLoading: _isLoading),
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
                ImportButton(onTap: _pickImage, isLoading: _isLoading),
              ],
            ),
          ),
        ),
        _buildTopRightActions(),
      ],
    );
  }
}
