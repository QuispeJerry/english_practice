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
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;
    
    final file = await _localFile;
    if (await file.exists()) {
      // If local file exists, load from it
      await _loadFromLocal();
    } else {
      // If no local file exists, load from asset and create local file
      await _loadFromAsset();
      await _saveToLocal();
    }
    _isInitialized = true;
  }

  Future<void> _loadFromAsset() async {
    final String response = await rootBundle.loadString('assets/$_fileName');
    final List<dynamic> data = json.decode(response);
    _items = data.map((item) => VocabularyItem.fromMap(item)).toList();
  }

  Future<void> _loadFromLocal() async {
    final file = await _localFile;
    final String localData = await file.readAsString();
    final List<dynamic> localItems = json.decode(localData);
    _items = localItems.map((item) => VocabularyItem.fromMap(item)).toList();
  }

  Future<File> get _localFile async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$_fileName');
  }

  Future<void> _saveToLocal() async {
    final file = await _localFile;
    final List<Map<String, dynamic>> jsonList = 
        _items.map((item) => item.toMap()).toList();
    await file.writeAsString(json.encode(jsonList));
  }

  // CRUD Operations
  List<VocabularyItem> getAll() => List.from(_items);

  Future<void> addItem(VocabularyItem item) async {
    _items.add(item);
    await _saveToLocal();
  }

  Future<void> updateItem(int index, VocabularyItem newItem) async {
    if (index >= 0 && index < _items.length) {
      _items[index] = newItem;
      await _saveToLocal();
    }
  }

  Future<void> deleteItem(int index) async {
    if (index >= 0 && index < _items.length) {
      _items.removeAt(index);
      await _saveToLocal();
    }
  }
}