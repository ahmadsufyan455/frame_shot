// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'style_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(frameStyles)
final frameStylesProvider = FrameStylesProvider._();

final class FrameStylesProvider
    extends
        $FunctionalProvider<
          List<FrameStyle>,
          List<FrameStyle>,
          List<FrameStyle>
        >
    with $Provider<List<FrameStyle>> {
  FrameStylesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'frameStylesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$frameStylesHash();

  @$internal
  @override
  $ProviderElement<List<FrameStyle>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<FrameStyle> create(Ref ref) {
    return frameStyles(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<FrameStyle> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<FrameStyle>>(value),
    );
  }
}

String _$frameStylesHash() => r'bd5f76123ffb5bc89f6b8f6c959b8ac4eaeac9bd';

@ProviderFor(SelectedStyle)
final selectedStyleProvider = SelectedStyleProvider._();

final class SelectedStyleProvider
    extends $NotifierProvider<SelectedStyle, FrameStyleId> {
  SelectedStyleProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedStyleProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedStyleHash();

  @$internal
  @override
  SelectedStyle create() => SelectedStyle();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FrameStyleId value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FrameStyleId>(value),
    );
  }
}

String _$selectedStyleHash() => r'4fcf10cb177e59aeb7b1649ceaa221fdfae17c9a';

abstract class _$SelectedStyle extends $Notifier<FrameStyleId> {
  FrameStyleId build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<FrameStyleId, FrameStyleId>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<FrameStyleId, FrameStyleId>,
              FrameStyleId,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
