import 'package:practice_english/models/VocabularyItem.dart';
import 'package:practice_english/database/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class VocabularyRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<List<VocabularyItem>> getVocabularyItems({int? folderId}) async {
    final db = await _dbHelper.database;
    List<Map<String, dynamic>> maps;
    if (folderId != null) {
      maps = await db.query('vocabulary', where: 'folderId = ?', whereArgs: [folderId]);
    } else {
      maps = await db.query('vocabulary');
    }
    return List.generate(maps.length, (i) {
      return VocabularyItem.fromMap(maps[i]);
    });
  }

  Future<int> insertVocabularyItem(VocabularyItem item) async {
    final db = await _dbHelper.database;
    return await db.insert('vocabulary', item.toMap());
  }

  Future<int> updateVocabularyItem(VocabularyItem item) async {
    final db = await _dbHelper.database;
    return await db.update('vocabulary', item.toMap(),
        where: 'id = ?', whereArgs: [item.id]);
  }

  Future<int> deleteVocabularyItem(int id) async {
    final db = await _dbHelper.database;
    return await db.delete('vocabulary', where: 'id = ?', whereArgs: [id]);
  }

  // Inserción en bloque (para importar desde JSON)
  Future<void> insertVocabularyItemsBulk(List<VocabularyItem> items) async {
    final db = await _dbHelper.database;
    Batch batch = db.batch();
    for (var item in items) {
      batch.insert('vocabulary', item.toMap());
    }
    await batch.commit(noResult: true);
  }
}
