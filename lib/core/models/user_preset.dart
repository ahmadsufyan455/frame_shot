import 'frame_config.dart';
import 'frame_style.dart';

class UserPreset {
  const UserPreset({
    required this.id,
    required this.name,
    required this.styleId,
    required this.config,
    required this.createdAt,
  });

  factory UserPreset.fromMap(Map<String, dynamic> map) {
    return UserPreset(
      id: map['id'] as String,
      name: map['name'] as String,
      styleId: FrameStyleId.values.byName(
        map['styleId'] as String,
      ),
      config: FrameConfig.fromMap(
        map['config'] as Map<String, dynamic>,
      ),
      createdAt: DateTime.parse(
        map['createdAt'] as String,
      ),
    );
  }

  final String id;
  final String name;
  final FrameStyleId styleId;
  final FrameConfig config;
  final DateTime createdAt;

  UserPreset copyWith({
    String? id,
    String? name,
    FrameStyleId? styleId,
    FrameConfig? config,
    DateTime? createdAt,
  }) {
    return UserPreset(
      id: id ?? this.id,
      name: name ?? this.name,
      styleId: styleId ?? this.styleId,
      config: config ?? this.config,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'styleId': styleId.name,
        'config': config.toMap(),
        'createdAt': createdAt.toIso8601String(),
      };

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserPreset && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
