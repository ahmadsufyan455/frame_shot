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
        isAutoDispose: false,
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

String _$selectedImageHash() => r'7f50b27aee2242c3a70937901d34554e2c122a28';

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

String _$exifExtractionHash() => r'21c9652338f3d03e4636306a77086418386441b6';

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

String _$previewImageHash() => r'a60c31ff08f7c52c6c35be892a39ee3ce97e4cdc';
