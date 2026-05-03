import 'dart:ui' as ui;

import 'package:flutter/services.dart';

abstract final class WatermarkLoader {
  static ui.Image? _cached;

  static Future<ui.Image> load() async {
    if (_cached != null) return _cached!;

    final data = await rootBundle.load(
      'assets/watermark/frameshot_logo.png',
    );
    final codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
    );
    final frame = await codec.getNextFrame();
    _cached = frame.image;
    return _cached!;
  }
}
