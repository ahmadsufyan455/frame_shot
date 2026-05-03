// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customize_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(EditedExif)
final editedExifProvider = EditedExifProvider._();

final class EditedExifProvider extends $NotifierProvider<EditedExif, ExifData> {
  EditedExifProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'editedExifProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$editedExifHash();

  @$internal
  @override
  EditedExif create() => EditedExif();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ExifData value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ExifData>(value),
    );
  }
}

String _$editedExifHash() => r'8c4cd7871f1a604cea37f31fc071245e1b2f85dd';

abstract class _$EditedExif extends $Notifier<ExifData> {
  ExifData build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<ExifData, ExifData>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ExifData, ExifData>,
              ExifData,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(FrameConfigNotifier)
final frameConfigProvider = FrameConfigNotifierProvider._();

final class FrameConfigNotifierProvider
    extends $NotifierProvider<FrameConfigNotifier, FrameConfig> {
  FrameConfigNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'frameConfigProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$frameConfigNotifierHash();

  @$internal
  @override
  FrameConfigNotifier create() => FrameConfigNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FrameConfig value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FrameConfig>(value),
    );
  }
}

String _$frameConfigNotifierHash() =>
    r'69b8b8e7bdae307e747353e647421bdb3f18b221';

abstract class _$FrameConfigNotifier extends $Notifier<FrameConfig> {
  FrameConfig build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<FrameConfig, FrameConfig>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<FrameConfig, FrameConfig>,
              FrameConfig,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
