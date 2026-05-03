import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'core/services/purchase_service.dart';
import 'core/services/storage_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.init();
  await _initPurchases();
  runApp(
    const ProviderScope(
      child: FrameShotApp(),
    ),
  );
}

Future<void> _initPurchases() async {
  // TODO: Replace with your RevenueCat API keys.
  const androidKey = 'your_revenuecat_android_api_key';
  const iosKey = 'your_revenuecat_ios_api_key';

  final apiKey = Platform.isAndroid ? androidKey : iosKey;

  if (kDebugMode && apiKey.startsWith('your_')) return;

  try {
    await PurchaseService.init(apiKey: apiKey);
  } on Exception {
    // Non-fatal: app works without IAP in free mode.
  }
}
