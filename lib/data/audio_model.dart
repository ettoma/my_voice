final String audioFiles = 'audioFiles';

class AudioFileFields {
  static final String id = '_id';
  static final String fileName = 'fileName';
  static final String mood = 'mood';
  static final String tag = 'tag';
}

class AudioFile {
  final int? id;
  final String fileName;
  final String mood;
  final String tag;

  AudioFile({
    required this.id,
    required this.fileName,
    required this.mood,
    required this.tag,
  });

  AudioFile copy({int? id, String? fileName, String? mood, String? tag}) =>
      AudioFile(
          id: id ?? this.id,
          fileName: fileName ?? this.fileName,
          mood: mood ?? this.mood,
          tag: tag ?? this.tag);

  Map<String, Object?> toJson() => {
        AudioFileFields.fileName: fileName,
        AudioFileFields.mood: mood,
        AudioFileFields.tag: tag,
      };
}
