import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

abstract final class ShareService {
  static Future<String> saveToGallery(
    Uint8List bytes, {
    required String fileName,
  }) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$fileName');
    await file.writeAsBytes(bytes);
    return file.path;
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
