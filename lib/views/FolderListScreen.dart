import 'package:flutter/material.dart';
import 'package:practice_english/models/Folder.dart';
import 'package:practice_english/models/VocabularyItem.dart';
import 'package:practice_english/repository/folder_repository.dart';
import 'FolderDetailScreen.dart';
import 'QuizScreen.dart';
import '../widgets/AddFolderDialog.dart';
import '../repository/vocabulary_repository.dart';

class FolderListScreen extends StatefulWidget {
  @override
  _FolderListScreenState createState() => _FolderListScreenState();
}

class _FolderListScreenState extends State<FolderListScreen> {
  final FolderRepository _folderRepo = FolderRepository();
  List<Folder> _folders = [];

  @override
  void initState() {
    super.initState();
    _loadFolders();
  }

  Future<void> _loadFolders() async {
    final folders = await _folderRepo.getAllFolders();
    setState(() {
      _folders = folders;
    });
  }

  void _addFolder() async {
    // Se muestra el diálogo para crear folder con 3 opciones.
    final result = await showDialog<FolderWithVocabulary>(
      context: context,
      builder: (context) => AddFolderDialog(),
    );

    if (result != null) {
      // Se inserta el folder y se obtendrá su ID.
      int folderId = await _folderRepo.insertFolder(result.folder);
      // Si se importaron palabras, se actualiza su folderId y se guardan.
      if (result.vocabularyItems != null && result.vocabularyItems!.isNotEmpty) {
        for (var item in result.vocabularyItems!) {
          item.folderId = folderId;
        }
        await VocabularyRepository().insertVocabularyItemsBulk(result.vocabularyItems!);
      }
      _loadFolders();
    }
  }

  void _deleteFolder(Folder folder) async {
    await _folderRepo.deleteFolder(folder.id!);
    _loadFolders();
  }

  // Iniciar quiz global (todas las palabras de todos los folders)
  void _startGlobalQuiz() async {
    var vocabularyItems = await VocabularyRepository().getVocabularyItems();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuizScreen(vocabularyList: vocabularyItems),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Folders'),
        actions: [
          IconButton(
            icon: Icon(Icons.quiz),
            onPressed: _startGlobalQuiz,
            tooltip: 'Start Global Quiz',
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _addFolder,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _folders.length,
        itemBuilder: (context, index) {
          final folder = _folders[index];
          return Dismissible(
            key: Key(folder.id.toString()),
            background: Container(color: Colors.red),
            onDismissed: (_) => _deleteFolder(folder),
            child: ListTile(
              title: Text(folder.name),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FolderDetailScreen(folder: folder),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

// Clase auxiliar para agrupar el folder y las palabras opcionales importadas.

class FolderWithVocabulary {
  final Folder folder;
  final List<VocabularyItem> vocabularyItems;
  
  FolderWithVocabulary({required this.folder, required this.vocabularyItems});
}

