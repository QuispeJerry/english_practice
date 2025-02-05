import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:practice_english/models/VocabularyItem.dart';

class VocabularyRepository {
  static final VocabularyRepository _instance = VocabularyRepository._internal();
  factory VocabularyRepository() => _instance;
  VocabularyRepository._internal();

  List<VocabularyItem> _items = [];
  final String _fileName = 'english_vocabulary.json';

  Future<void> initialize() async {
    await _loadFromAsset();
    await _mergeWithLocal();
  }

  Future<void> _loadFromAsset() async {
    final String response = await rootBundle.loadString('assets/$_fileName');
    final List<dynamic> data = json.decode(response);
    _items = data.map((item) => VocabularyItem.fromJson(item)).toList();
  }

  Future<File> get _localFile async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$_fileName');
  }

  Future<void> _mergeWithLocal() async {
    final file = await _localFile;
    if (await file.exists()) {
      final String localData = await file.readAsString();
      final List<dynamic> localItems = json.decode(localData);
      _items = [
        ..._items,
        ...localItems.map((item) => VocabularyItem.fromJson(item))
      ].toSet().toList(); // Evita duplicados
    }
  }

  Future<void> _saveToLocal() async {
    final file = await _localFile;
    final List<Map<String, dynamic>> jsonList = 
        _items.map((item) => item.toJson()).toList();
    await file.writeAsString(json.encode(jsonList));
  }

  // Operaciones CRUD
  List<VocabularyItem> getAll() => List.from(_items);

  Future<void> addItem(VocabularyItem item) async {
    _items.add(item);
    await _saveToLocal();
  }

  Future<void> updateItem(int index, VocabularyItem newItem) async {
    _items[index] = newItem;
    await _saveToLocal();
  }

  Future<void> deleteItem(int index) async {
    _items.removeAt(index);
    await _saveToLocal();
  }
}

