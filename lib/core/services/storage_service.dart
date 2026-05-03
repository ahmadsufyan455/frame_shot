import 'package:shared_preferences/shared_preferences.dart';

import '../models/frame_style.dart';

abstract final class StorageService {
  static const _keyLastStyleId = 'last_style_id';
  static const _keyLocationEnabled = 'location_enabled';
  static const _keyFullResolutionExport = 'full_resolution_export';
  static const _keyOnboardingComplete = 'onboarding_complete';

  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static SharedPreferences get _instance {
    assert(
      _prefs != null,
      'StorageService.init() must be called before use.',
    );
    return _prefs!;
  }

  // -- Last used style --

  static FrameStyleId getLastStyleId() {
    final name = _instance.getString(_keyLastStyleId);
    if (name == null) return FrameStyleId.classic;
    return FrameStyleId.values.asNameMap()[name] ??
        FrameStyleId.classic;
  }

  static Future<void> setLastStyleId(
    FrameStyleId styleId,
  ) async {
    await _instance.setString(
      _keyLastStyleId,
      styleId.name,
    );
  }

  // -- Location opt-in --

  static bool getLocationEnabled() {
    return _instance.getBool(_keyLocationEnabled) ?? false;
  }

  static Future<void> setLocationEnabled(bool enabled) async {
    await _instance.setBool(_keyLocationEnabled, enabled);
  }

  // -- Full resolution export --

  static bool getFullResolutionExport() {
    return _instance.getBool(_keyFullResolutionExport) ??
        false;
  }

  static Future<void> setFullResolutionExport(
    bool enabled,
  ) async {
    await _instance.setBool(
      _keyFullResolutionExport,
      enabled,
    );
  }

  // -- Onboarding --

  static bool getOnboardingComplete() {
    return _instance.getBool(_keyOnboardingComplete) ?? false;
  }

  static Future<void> setOnboardingComplete(
    bool complete,
  ) async {
    await _instance.setBool(_keyOnboardingComplete, complete);
  }
}
