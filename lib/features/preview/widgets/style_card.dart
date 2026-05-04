import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../../core/models/exif_data.dart';
import '../../../core/models/frame_style.dart';
import '../../../core/rendering/frame_painter_factory.dart';

class StyleCard extends StatelessWidget {
  const StyleCard({
    super.key,
    required this.style,
    required this.isSelected,
    required this.onTap,
    this.isUserPro = false,
    this.image,
    this.exif,
    this.cameraLogo,
  });

  final FrameStyle style;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isUserPro;
  final ui.Image? image;
  final ExifData? exif;
  final ui.Image? cameraLogo;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: isSelected ? 1.0 : 0.6,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedScale(
              duration: const Duration(milliseconds: 200),
              scale: isSelected ? 1.05 : 1.0,
              child: _buildCard(),
            ),
            const SizedBox(height: 6),
            Text(
              style.name,
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : const Color(0xFF9CA3AF),
                fontSize: 10,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.3,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard() {
    if (isSelected) {
      return Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: const Color(0xFF0A0A0A),
        ),
        child: Container(
          width: 64,
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: Colors.white,
              width: 2,
            ),
          ),
          child: _buildCardContent(14),
        ),
      );
    }

    return Container(
      width: 64,
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
        ),
      ),
      child: _buildCardContent(14),
    );
  }

  Widget _buildCardContent(double radius) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(
        isSelected ? radius - 2 : radius - 1,
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          _buildMiniaturePreview(),
          if (style.isPro && !isUserPro) _buildLockOverlay(),
        ],
      ),
    );
  }

  Widget _buildMiniaturePreview() {
    if (image == null) {
      return Container(
        color: style.defaultConfig.backgroundColor,
      );
    }

    final painter = FramePainterFactory.create(
      styleId: style.id,
      image: image!,
      exif: exif ?? ExifData.empty,
      config: style.defaultConfig,
      cameraLogo: cameraLogo,
    );

    final totalSize = painter.calculateTotalSize(
      painter.imageSize,
    );

    return RepaintBoundary(
      child: FittedBox(
        fit: BoxFit.cover,
        clipBehavior: Clip.hardEdge,
        child: CustomPaint(
          size: totalSize,
          painter: painter,
        ),
      ),
    );
  }

  Widget _buildLockOverlay() {
    return Container(
      color: Colors.black.withValues(alpha: 0.5),
      child: Center(
        child: Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.6),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.lock,
            size: 12,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
