import 'dart:io';
import 'dart:typed_data';

import 'package:gal/gal.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

abstract final class ShareService {
  static Future<String> saveToGallery(
    Uint8List bytes, {
    required String fileName,
  }) async {
    final hasAccess = await Gal.hasAccess();
    if (!hasAccess) {
      final granted = await Gal.requestAccess();
      if (!granted) {
        throw Exception(
          'Photo library permission denied',
        );
      }
    }
    // Gal appends the file extension automatically,
    // so strip it to avoid double extensions (e.g. .jpg.jpg).
    final baseName = fileName.contains('.')
        ? fileName.substring(0, fileName.lastIndexOf('.'))
        : fileName;
    await Gal.putImageBytes(bytes, name: baseName);
    return 'gallery://$fileName';
  }

  static Future<void> shareToApp(
    Uint8List bytes, {
    required String fileName,
    String? mimeType,
  }) async {
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/$fileName');
    await file.writeAsBytes(bytes);

    await Share.shareXFiles(
      [XFile(file.path, mimeType: mimeType)],
    );
  }
}
