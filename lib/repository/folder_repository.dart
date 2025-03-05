import 'package:practice_english/models/Folder.dart';
import 'package:practice_english/database/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class FolderRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<List<Folder>> getAllFolders() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('folders');
    return List.generate(maps.length, (i) {
      return Folder.fromMap(maps[i]);
    });
  }

  Future<int> insertFolder(Folder folder) async {
    final db = await _dbHelper.database;
    return await db.insert('folders', folder.toMap());
  }

  Future<int> updateFolder(Folder folder) async {
    final db = await _dbHelper.database;
    return await db.update('folders', folder.toMap(),
        where: 'id = ?', whereArgs: [folder.id]);
  }

  Future<int> deleteFolder(int id) async {
    final db = await _dbHelper.database;
    return await db.delete('folders', where: 'id = ?', whereArgs: [id]);
  }
}
