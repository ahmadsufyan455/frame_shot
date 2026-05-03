import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/models/frame_style.dart';
import '../../../core/services/purchase_service.dart';
import '../../../core/services/storage_service.dart';

part 'settings_providers.g.dart';

// -- AppSettings model --

class AppSettings {
  const AppSettings({
    this.locationEnabled = false,
    this.lastStyleId = FrameStyleId.classic,
    this.onboardingComplete = false,
  });

  final bool locationEnabled;
  final FrameStyleId lastStyleId;
  final bool onboardingComplete;

  AppSettings copyWith({
    bool? locationEnabled,
    FrameStyleId? lastStyleId,
    bool? onboardingComplete,
  }) {
    return AppSettings(
      locationEnabled:
          locationEnabled ?? this.locationEnabled,
      lastStyleId: lastStyleId ?? this.lastStyleId,
      onboardingComplete:
          onboardingComplete ?? this.onboardingComplete,
    );
  }
}

// -- TASK-060: settingsProvider --

@Riverpod(keepAlive: true)
class Settings extends _$Settings {
  @override
  AppSettings build() {
    return AppSettings(
      locationEnabled:
          StorageService.getLocationEnabled(),
      lastStyleId: StorageService.getLastStyleId(),
      onboardingComplete:
          StorageService.getOnboardingComplete(),
    );
  }

  Future<void> setLocationEnabled(bool enabled) async {
    await StorageService.setLocationEnabled(enabled);
    state = state.copyWith(locationEnabled: enabled);
  }

  Future<void> setLastStyleId(
    FrameStyleId styleId,
  ) async {
    await StorageService.setLastStyleId(styleId);
    state = state.copyWith(lastStyleId: styleId);
  }

  Future<void> setOnboardingComplete(
    bool complete,
  ) async {
    await StorageService.setOnboardingComplete(
      complete,
    );
    state = state.copyWith(
      onboardingComplete: complete,
    );
  }
}

// -- TASK-061: proStatusProvider --

@Riverpod(keepAlive: true)
class ProStatus extends _$ProStatus {
  @override
  Future<bool> build() async {
    if (kDebugMode && DebugFlags.forceProEnabled) {
      return true;
    }
    return PurchaseService.checkProStatus();
  }

  Future<void> purchase() async {
    state = const AsyncLoading();
    final success = await PurchaseService.purchase();
    state = AsyncData(success);
  }

  Future<void> restore() async {
    state = const AsyncLoading();
    final success = await PurchaseService.restore();
    state = AsyncData(success);
  }
}
