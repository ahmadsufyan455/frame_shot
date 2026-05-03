// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preview_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SelectedImage)
final selectedImageProvider = SelectedImageProvider._();

final class SelectedImageProvider
    extends $NotifierProvider<SelectedImage, ImageFile?> {
  SelectedImageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedImageProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedImageHash();

  @$internal
  @override
  SelectedImage create() => SelectedImage();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ImageFile? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ImageFile?>(value),
    );
  }
}

String _$selectedImageHash() => r'b38644f59db78c9816c77e07b59977366dde6aa4';

abstract class _$SelectedImage extends $Notifier<ImageFile?> {
  ImageFile? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<ImageFile?, ImageFile?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ImageFile?, ImageFile?>,
              ImageFile?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(ExifExtraction)
final exifExtractionProvider = ExifExtractionProvider._();

final class ExifExtractionProvider
    extends $AsyncNotifierProvider<ExifExtraction, ExifData?> {
  ExifExtractionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'exifExtractionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$exifExtractionHash();

  @$internal
  @override
  ExifExtraction create() => ExifExtraction();
}

String _$exifExtractionHash() => r'31c70e653d4f824517758087b5f701dc6e453722';

abstract class _$ExifExtraction extends $AsyncNotifier<ExifData?> {
  FutureOr<ExifData?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<ExifData?>, ExifData?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ExifData?>, ExifData?>,
              AsyncValue<ExifData?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(frameRenderData)
final frameRenderDataProvider = FrameRenderDataProvider._();

final class FrameRenderDataProvider
    extends
        $FunctionalProvider<FrameRenderData, FrameRenderData, FrameRenderData>
    with $Provider<FrameRenderData> {
  FrameRenderDataProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'frameRenderDataProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$frameRenderDataHash();

  @$internal
  @override
  $ProviderElement<FrameRenderData> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  FrameRenderData create(Ref ref) {
    return frameRenderData(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FrameRenderData value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FrameRenderData>(value),
    );
  }
}

String _$frameRenderDataHash() => r'b82eddd504c601e9c6b4dcb0c655031524825715';

@ProviderFor(previewImage)
final previewImageProvider = PreviewImageProvider._();

final class PreviewImageProvider
    extends
        $FunctionalProvider<
          AsyncValue<ui.Image?>,
          ui.Image?,
          FutureOr<ui.Image?>
        >
    with $FutureModifier<ui.Image?>, $FutureProvider<ui.Image?> {
  PreviewImageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'previewImageProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$previewImageHash();

  @$internal
  @override
  $FutureProviderElement<ui.Image?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<ui.Image?> create(Ref ref) {
    return previewImage(ref);
  }
}

String _$previewImageHash() => r'3edbd3c1e3d1493b8be4addfb9206e52bd79659d';

@ProviderFor(locationPermission)
final locationPermissionProvider = LocationPermissionProvider._();

final class LocationPermissionProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  LocationPermissionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'locationPermissionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$locationPermissionHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return locationPermission(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$locationPermissionHash() =>
    r'ca0283dc2b4de7f619ad459eb047e6a04af3e085';

@ProviderFor(reverseGeocode)
final reverseGeocodeProvider = ReverseGeocodeFamily._();

final class ReverseGeocodeProvider
    extends $FunctionalProvider<AsyncValue<String?>, String?, FutureOr<String?>>
    with $FutureModifier<String?>, $FutureProvider<String?> {
  ReverseGeocodeProvider._({
    required ReverseGeocodeFamily super.from,
    required (double, double) super.argument,
  }) : super(
         retry: null,
         name: r'reverseGeocodeProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$reverseGeocodeHash();

  @override
  String toString() {
    return r'reverseGeocodeProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<String?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String?> create(Ref ref) {
    final argument = this.argument as (double, double);
    return reverseGeocode(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is ReverseGeocodeProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$reverseGeocodeHash() => r'c70d50d4f72b5484c032bf52d33f14b446a29085';

final class ReverseGeocodeFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<String?>, (double, double)> {
  ReverseGeocodeFamily._()
    : super(
        retry: null,
        name: r'reverseGeocodeProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ReverseGeocodeProvider call(double latitude, double longitude) =>
      ReverseGeocodeProvider._(argument: (latitude, longitude), from: this);

  @override
  String toString() => r'reverseGeocodeProvider';
}
