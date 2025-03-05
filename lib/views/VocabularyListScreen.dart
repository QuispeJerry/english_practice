import 'package:flutter/material.dart';
import 'package:practice_english/models/VocabularyItem.dart';
import 'package:practice_english/repository/VocabularyRepository.dart';
import 'package:practice_english/views/QuizScreen.dart';
import 'package:practice_english/widgets/AddVocabularyForm.dart';

class VocabularyListScreen extends StatefulWidget {
  @override
  _VocabularyListScreenState createState() => _VocabularyListScreenState();
}

class _VocabularyListScreenState extends State<VocabularyListScreen> {
  final VocabularyRepository _repository = VocabularyRepository();
  late List<VocabularyItem> _items;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await _repository.initialize();
    setState(() {
      _items = _repository.getAll();
    });
  }

  // Future<void> _addNewWord() async {
  //   final newItem = VocabularyItem(
  //     word: 'New Word',
  //     translation: 'Nueva Palabra',
  //     meaning: 'New meaning',
  //     note: '',
  //   );

  //   await _repository.addItem(newItem);
  //   _refreshList();
  // }

  Future<void> _addNewWord() async {
    final newItem = await showDialog<VocabularyItem>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Agregar nueva palabra'),
        content: SingleChildScrollView(
          child: AddVocabularyForm(),
        ),
      ),
    );

    if (newItem != null) {
      await _repository.addItem(newItem);
      _refreshList();
    }
  }

  Future<void> _editWord(int index) async {
    final itemToEdit = _items[index];
    final editedItem = await showDialog<VocabularyItem>(
      context: context,
      builder: (context) => EditVocabularyDialog(item: itemToEdit),
    );

    if (editedItem != null) {
      await _repository.updateItem(index, editedItem);
      _refreshList();
    }
  }

  Future<void> _deleteWord(int index) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Eliminar palabra'),
        content: Text('¿Estás seguro de que quieres eliminar esta palabra?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _repository.deleteItem(index);
      _refreshList();
    }
  }

  void _refreshList() {
    setState(() {
      _items = _repository.getAll();
    });
  }

  Widget _buildVocabularyCard(VocabularyItem item) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item.word,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800],
                  ),
                ),
                Text(
                  item.translation,
                  style: TextStyle(
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                    color: Colors.green[800],
                  ),
                ),
              ],
            ),
            Divider(color: Colors.grey[300], height: 24),
            Text(
              'Meaning:',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 4),
            Text(
              item.meaning,
              style: TextStyle(fontSize: 16),
            ),
            if (item.note.isNotEmpty) ...[
              SizedBox(height: 12),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.amber[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.note, size: 18, color: Colors.amber[700]),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        item.note,
                        style: TextStyle(
                          color: Colors.amber[900],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('English Vocabulary'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _addNewWord,
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuizScreen(
                      vocabularyList: _repository.getAll(),
                    ),
                  ),
                );
              },
              child: Text('Start Quiz'),
            ),
        ],
      ),
      body: ListView.builder(
        itemCount: _items.length,
        itemBuilder: (context, index) {
          final item = _items[index];
          return Dismissible(
            key: Key(item.word),
            background: Container(color: Colors.red),
            onDismissed: (_) => _deleteWord(index),
            child: GestureDetector(
              onTap: () => _editWord(index),
              child: _buildVocabularyCard(item),
            ),
          );
        },
      ),
    );
  }
}

class EditVocabularyDialog extends StatefulWidget {
  final VocabularyItem item;

  const EditVocabularyDialog({required this.item});

  @override
  _EditVocabularyDialogState createState() => _EditVocabularyDialogState();
}

class _EditVocabularyDialogState extends State<EditVocabularyDialog> {
  late TextEditingController _wordController;
  late TextEditingController _translationController;
  late TextEditingController _meaningController;
  late TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    _wordController = TextEditingController(text: widget.item.word);
    _translationController =
        TextEditingController(text: widget.item.translation);
    _meaningController = TextEditingController(text: widget.item.meaning);
    _noteController = TextEditingController(text: widget.item.note);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Editar palabra'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _wordController,
              decoration: InputDecoration(labelText: 'Palabra en inglés'),
            ),
            TextField(
              controller: _translationController,
              decoration: InputDecoration(labelText: 'Traducción'),
            ),
            TextField(
              controller: _meaningController,
              decoration: InputDecoration(labelText: 'Significado'),
            ),
            TextField(
              controller: _noteController,
              decoration: InputDecoration(labelText: 'Nota'),
              maxLines: 3,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            final editedItem = widget.item.copyWith(
              word: _wordController.text,
              translation: _translationController.text,
              meaning: _meaningController.text,
              note: _noteController.text,
            );
            Navigator.pop(context, editedItem);
          },
          child: Text('Guardar'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _wordController.dispose();
    _translationController.dispose();
    _meaningController.dispose();
    _noteController.dispose();
    super.dispose();
  }
}
