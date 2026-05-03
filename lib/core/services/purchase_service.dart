import 'package:purchases_flutter/purchases_flutter.dart';

abstract final class PurchaseService {
  static const _entitlementId = 'pro';

  static Future<void> init({
    required String apiKey,
  }) async {
    await Purchases.configure(
      PurchasesConfiguration(apiKey),
    );
  }

  static Future<bool> checkProStatus() async {
    try {
      final info = await Purchases.getCustomerInfo();
      return info.entitlements.active
          .containsKey(_entitlementId);
    } on Exception {
      return false;
    }
  }

  static Future<bool> purchase() async {
    try {
      final offerings = await Purchases.getOfferings();
      final current = offerings.current;
      if (current == null) return false;

      final package = current.lifetime;
      if (package == null) return false;

      final result = await Purchases.purchase(
        PurchaseParams.package(package),
      );
      return result.customerInfo.entitlements.active
          .containsKey(_entitlementId);
    } on Exception {
      return false;
    }
  }

  static Future<bool> restore() async {
    try {
      final info = await Purchases.restorePurchases();
      return info.entitlements.active
          .containsKey(_entitlementId);
    } on Exception {
      return false;
    }
  }
}
