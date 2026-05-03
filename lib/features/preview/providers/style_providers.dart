import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/constants/frame_styles.dart';
import '../../../core/models/frame_style.dart';
import '../../settings/providers/settings_providers.dart';

part 'style_providers.g.dart';

// -- TASK-065: frameStylesProvider --

@riverpod
List<FrameStyle> frameStyles(Ref ref) {
  return FrameStyles.all;
}

// -- TASK-065: selectedStyleProvider --

@riverpod
class SelectedStyle extends _$SelectedStyle {
  @override
  FrameStyleId build() {
    final settings = ref.watch(settingsProvider);
    return settings.lastStyleId;
  }

  Future<void> select(FrameStyleId styleId) async {
    state = styleId;
    await ref
        .read(settingsProvider.notifier)
        .setLastStyleId(styleId);
  }
}
