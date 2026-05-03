import 'dart:ui' as ui;

import '../models/exif_data.dart';
import '../models/frame_config.dart';
import '../models/frame_style.dart';
import 'frame_painter.dart';
import 'painters/architect_painter.dart';
import 'painters/classic_painter.dart';
import 'painters/darkroom_painter.dart';
import 'painters/film_border_painter.dart';
import 'painters/fujifilm_sim_painter.dart';
import 'painters/minimal_line_painter.dart';

abstract final class FramePainterFactory {
  static FramePainter create({
    required FrameStyleId styleId,
    required ui.Image image,
    required ExifData exif,
    required FrameConfig config,
    ui.Image? watermark,
  }) {
    return switch (styleId) {
      FrameStyleId.classic => ClassicPainter(
          image: image,
          exif: exif,
          config: config,
          watermark: watermark,
        ),
      FrameStyleId.darkroom => DarkroomPainter(
          image: image,
          exif: exif,
          config: config,
          watermark: watermark,
        ),
      FrameStyleId.filmBorder => FilmBorderPainter(
          image: image,
          exif: exif,
          config: config,
          watermark: watermark,
        ),
      FrameStyleId.minimalLine =>
        MinimalLinePainter(
          image: image,
          exif: exif,
          config: config,
          watermark: watermark,
        ),
      FrameStyleId.fujifilmSim =>
        FujifilmSimPainter(
          image: image,
          exif: exif,
          config: config,
          watermark: watermark,
        ),
      FrameStyleId.architect => ArchitectPainter(
          image: image,
          exif: exif,
          config: config,
          watermark: watermark,
        ),
    };
  }
}
