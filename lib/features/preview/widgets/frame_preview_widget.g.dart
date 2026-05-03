// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'frame_preview_widget.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(cameraLogoImage)
final cameraLogoImageProvider = CameraLogoImageProvider._();

final class CameraLogoImageProvider
    extends
        $FunctionalProvider<
          AsyncValue<ui.Image?>,
          ui.Image?,
          FutureOr<ui.Image?>
        >
    with $FutureModifier<ui.Image?>, $FutureProvider<ui.Image?> {
  CameraLogoImageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cameraLogoImageProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cameraLogoImageHash();

  @$internal
  @override
  $FutureProviderElement<ui.Image?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<ui.Image?> create(Ref ref) {
    return cameraLogoImage(ref);
  }
}

String _$cameraLogoImageHash() => r'213d3b2e44adb62c7ad322fad0ddd50d50687a77';
