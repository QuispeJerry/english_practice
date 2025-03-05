import 'package:flutter/material.dart';
import 'package:practice_english/models/Folder.dart';
import 'package:practice_english/models/VocabularyItem.dart';
import 'package:practice_english/repository/vocabulary_repository.dart';
import 'package:practice_english/views/VocabularyListScreen.dart';
import 'QuizScreen.dart';
import '../widgets/AddVocabularyForm.dart';

class FolderDetailScreen extends StatefulWidget {
  final Folder folder;

  FolderDetailScreen({required this.folder});

  @override
  _FolderDetailScreenState createState() => _FolderDetailScreenState();
}

class _FolderDetailScreenState extends State<FolderDetailScreen> {
  final VocabularyRepository _vocabRepo = VocabularyRepository();
  List<VocabularyItem> _vocabularyItems = [];

  @override
  void initState() {
    super.initState();
    _loadVocabulary();
  }

  Future<void> _loadVocabulary() async {
    final items =
        await _vocabRepo.getVocabularyItems(folderId: widget.folder.id!);
    setState(() {
      _vocabularyItems = items;
    });
  }

  void _addVocabulary() async {
    final newItem = await showDialog<VocabularyItem>(
      context: context,
      builder: (context) => Dialog(
        child: AddVocabularyForm(folderId: widget.folder.id!),
      ),
    );

    if (newItem != null) {
      await _vocabRepo.insertVocabularyItem(newItem);
      _loadVocabulary();
    }
  }

  void _deleteVocabulary(VocabularyItem item) async {
    await _vocabRepo.deleteVocabularyItem(item.id!);
    _loadVocabulary();
  }

  void _editVocabulary(VocabularyItem item) async {
    final editedItem = await showDialog<VocabularyItem>(
      context: context,
      builder: (context) => EditVocabularyDialog(item: item),
    );
    if (editedItem != null) {
      await _vocabRepo.updateVocabularyItem(editedItem);
      _loadVocabulary();
    }
  }

  void _startQuiz() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuizScreen(vocabularyList: _vocabularyItems),
      ),
    );
  }

  Widget _buildVocabularyCard(VocabularyItem item) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: InkWell(
        onTap: () => _editVocabulary(item),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.word,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800]),
              ),
              SizedBox(height: 4),
              Text(
                item.translation,
                style: TextStyle(
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                    color: Colors.green[800]),
              ),
              if (item.meaning.trim().isNotEmpty) ...[
                SizedBox(height: 8),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Meaning: ',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500), // Negrita
                      ),
                      TextSpan(
                        text: '${item.meaning}',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal), // Normal
                      ),
                    ],
                  ),
                )
              ],
              if (item.note.trim().isNotEmpty) ...[
                SizedBox(height: 8),
                // Text(
                //   'Note: ${item.note}',
                //   style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                // ),

                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Note: ',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500), // Negrita
                      ),
                      TextSpan(
                        text: '${item.note}',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal), // Normal
                      ),
                    ],
                  ),
                )
              ],
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.folder.name),
        actions: [
          IconButton(
            icon: Icon(Icons.quiz),
            onPressed: _startQuiz,
            tooltip: 'Start Quiz for this Folder',
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _addVocabulary,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _vocabularyItems.length,
        itemBuilder: (context, index) {
          return _buildVocabularyCard(_vocabularyItems[index]);
        },
      ),
    );
  }
}
