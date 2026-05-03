class ImageFile {
  const ImageFile({
    required this.path,
    required this.name,
    required this.sizeBytes,
    this.width,
    this.height,
  });

  final String path;
  final String name;
  final int sizeBytes;
  final int? width;
  final int? height;

  String get displaySize {
    if (sizeBytes < 1024) return '$sizeBytes B';
    if (sizeBytes < 1024 * 1024) {
      return '${(sizeBytes / 1024).toStringAsFixed(1)} KB';
    }
    return '${(sizeBytes / (1024 * 1024)).toStringAsFixed(1)}'
        ' MB';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ImageFile &&
        other.path == path &&
        other.name == name &&
        other.sizeBytes == sizeBytes &&
        other.width == width &&
        other.height == height;
  }

  @override
  int get hashCode => Object.hash(
        path,
        name,
        sizeBytes,
        width,
        height,
      );
}
