import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/models/image_file.dart';
import '../preview/providers/preview_providers.dart';
import 'widgets/import_button.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FrameShot'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.pushNamed('settings'),
          ),
        ],
      ),
      body: Center(
        child: ImportButton(
          onTap: () => _pickImage(context, ref),
        ),
      ),
    );
  }

  Future<void> _pickImage(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final picker = ImagePicker();
    final xFile = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (xFile == null) return;

    final file = File(xFile.path);
    final stat = await file.stat();

    ref.read(selectedImageProvider.notifier).set(
          ImageFile(
            path: xFile.path,
            name: xFile.name,
            sizeBytes: stat.size,
          ),
        );

    if (context.mounted) {
      await context.pushNamed('preview');
    }
  }
}
