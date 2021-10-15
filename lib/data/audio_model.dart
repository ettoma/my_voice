const String audioFiles = 'audioFiles';

class AudioFileFields {
  static final List<String> values = [id, fileName, mood, tag];

  static const String id = '_id';
  static const String fileName = 'fileName';
  static const String mood = 'mood';
  static const String tag = 'tag';
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

  static AudioFile fromJson(Map<String, Object?> json) => AudioFile(
      id: json[AudioFileFields.id] as int?,
      fileName: json[AudioFileFields.fileName] as String,
      mood: json[AudioFileFields.mood] as String,
      tag: json[AudioFileFields.tag] as String);
}
