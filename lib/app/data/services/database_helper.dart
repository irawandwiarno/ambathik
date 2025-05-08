import 'dart:convert';
import 'package:ambathik/app/data/models/history.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'history.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE history (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            image_path TEXT NOT NULL,
            label TEXT NOT NULL,
            prediction TEXT NOT NULL,
            model_name TEXT NOT NULL,
            is_identified INTEGER NOT NULL DEFAULT 1
          )
        ''');
      },
    );
  }

  Future<int> insertHistory(History history) async {
    final db = await database;
    return await db.insert('history', history.toMap());
  }

  Future<List<History>> getAllHistory() async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query('history', orderBy: 'id DESC');
    return maps.map((map) => History.fromMap(map)).toList();
  }

  Future<History?> getHistoryById(int id) async {
    final db = await database;
    final maps = await db.query(
      'history',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return History.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> deleteHistoryById(int id) async {
    final db = await database;
    return await db.delete(
      'history',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteAllHistory() async {
    final db = await database;
    await db.delete('history');
  }
}
