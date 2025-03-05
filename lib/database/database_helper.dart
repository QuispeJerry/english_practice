import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    // Inicialización de la base de datos
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
  final directory = await getApplicationDocumentsDirectory();
  final path = join(directory.path, 'english_vocabulary.db');

  return await openDatabase(
    path,
    version: 1,
    onConfigure: (db) async {
      // Activa las restricciones de claves foráneas
      await db.execute('PRAGMA foreign_keys = ON');
    },
    onCreate: _onCreate,
  );
}

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE folders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE vocabulary (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        folderId INTEGER NOT NULL,
        word TEXT NOT NULL,
        translation TEXT NOT NULL,
        meaning TEXT NOT NULL,
        note TEXT,
        FOREIGN KEY (folderId) REFERENCES folders (id) ON DELETE CASCADE
      )
    ''');
  }
}
