import 'dart:math';

import 'package:flutter/material.dart';

class ImportButton extends StatefulWidget {
  const ImportButton({super.key, required this.onTap, this.isLoading = false});

  final VoidCallback onTap;
  final bool isLoading;

  @override
  State<ImportButton> createState() => _ImportButtonState();
}

class _ImportButtonState extends State<ImportButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: widget.isLoading ? null : widget.onTap,
          behavior: HitTestBehavior.opaque,
          child: SizedBox(
            width: 140,
            height: 140,
            child: widget.isLoading
                ? const Center(
                    child: SizedBox(
                      width: 48,
                      height: 48,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 3,
                      ),
                    ),
                  )
                : AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return CustomPaint(
                        painter: DashedCirclePainter(
                          color: Colors.white54,
                          dashWidth: 10,
                          dashSpace: 8,
                          strokeWidth: 2,
                          rotation: _controller.value * 2 * pi,
                        ),
                        child: Center(
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.05),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.add_rounded,
                              size: 48,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          widget.isLoading ? 'Reading EXIF metadata...' : 'IMPORT',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }
}

class DashedCirclePainter extends CustomPainter {
  DashedCirclePainter({
    required this.color,
    required this.dashWidth,
    required this.dashSpace,
    required this.strokeWidth,
    required this.rotation,
  });
  final Color color;
  final double dashWidth;
  final double dashSpace;
  final double strokeWidth;
  final double rotation;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final radius = (min(size.width, size.height) - strokeWidth) / 2;
    final center = Offset(size.width / 2, size.height / 2);
    final circumference = 2 * pi * radius;

    // Number of dashes to fit the circumference
    final int dashCount = (circumference / (dashWidth + dashSpace)).floor();

    // Calculate the actual angle for each dash and space
    final double dashAngle = (dashWidth / circumference) * 2 * pi;
    final double spaceAngle = (dashSpace / circumference) * 2 * pi;

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotation);

    double currentAngle = 0;
    for (int i = 0; i < dashCount; i++) {
      canvas.drawArc(
        Rect.fromCircle(center: Offset.zero, radius: radius),
        currentAngle,
        dashAngle,
        false,
        paint,
      );
      currentAngle += dashAngle + spaceAngle;
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant DashedCirclePainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.dashWidth != dashWidth ||
        oldDelegate.dashSpace != dashSpace ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.rotation != rotation;
  }
}
