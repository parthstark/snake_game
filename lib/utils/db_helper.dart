import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../models/high_score.dart';

class DatabaseHelper {
  DatabaseHelper._init();
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  // if _database is null, then create a new database
  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initializeDatabase();
    return _database;
  }

  // initailize database function
  Future<Database> _initializeDatabase() async {
    // get the directory path for both Android and iOS to store database
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "high_score.db");

    //return open/create the database at a given path
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE high_score (
        id INTEGER PRIMARY KEY,
        score INTEGER NOT NULL,
        date TEXT NOT NULL
      )
    ''');
  }

  Future close() async {
    final db = await instance.database;
    db!.close();
  }

  Future<Score> create(Score currScore) async {
    final db = await instance.database;
    currScore.id = await db!.insert('high_score', currScore.toMap());
    return currScore;
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db!.delete('high_score', where: 'id = $id');
  }

  Future<List<Score>> getScores() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> scores =
        await db!.query('high_score', orderBy: 'score DESC');
    List<Score> highScores = scores.isNotEmpty
        ? scores.map((score) => Score.fromMap(score)).toList()
        : [];
    return highScores;
  }
}
