// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'export_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ExportNotifier)
final exportProvider = ExportNotifierProvider._();

final class ExportNotifierProvider
    extends $NotifierProvider<ExportNotifier, ExportState> {
  ExportNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'exportProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$exportNotifierHash();

  @$internal
  @override
  ExportNotifier create() => ExportNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ExportState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ExportState>(value),
    );
  }
}

String _$exportNotifierHash() => r'7d4ba6416ade3c9e96422c358011e19d95fe4593';

abstract class _$ExportNotifier extends $Notifier<ExportState> {
  ExportState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<ExportState, ExportState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ExportState, ExportState>,
              ExportState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(BatchExportNotifier)
final batchExportProvider = BatchExportNotifierProvider._();

final class BatchExportNotifierProvider
    extends $NotifierProvider<BatchExportNotifier, BatchExportState> {
  BatchExportNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'batchExportProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$batchExportNotifierHash();

  @$internal
  @override
  BatchExportNotifier create() => BatchExportNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BatchExportState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BatchExportState>(value),
    );
  }
}

String _$batchExportNotifierHash() =>
    r'c46fa4f73acd4c62609921140341569241b604f4';

abstract class _$BatchExportNotifier extends $Notifier<BatchExportState> {
  BatchExportState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<BatchExportState, BatchExportState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<BatchExportState, BatchExportState>,
              BatchExportState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
