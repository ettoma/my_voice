import 'package:audio_journal/data/audio_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:sqflite/sqflite.dart';

class AudioDatabase {
  static final AudioDatabase instance = AudioDatabase._init();
  static Database? _database;
  AudioDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('audio.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dBPath = await getApplicationDocumentsDirectory();
    final path = join(dBPath.path, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final textType = 'TEXT NOT NULL';
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';

    await db.execute('''
    CREATE TABLE $audioFiles(
      ${AudioFileFields.id} $idType,
      ${AudioFileFields.fileName} $textType,
      ${AudioFileFields.mood} $textType,
      ${AudioFileFields.tag} $textType

    )
    ''');
  }

  Future<AudioFile> create(AudioFile audioFile) async {
    final db = await instance.database;
    final id = await db.insert(audioFiles, audioFile.toJson());
    return audioFile.copy(id: id);
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
