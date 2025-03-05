import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:practice_english/models/Folder.dart';
import 'package:practice_english/models/VocabularyItem.dart';
import 'package:practice_english/views/FolderListScreen.dart';

class AddFolderDialog extends StatefulWidget {
  @override
  _AddFolderDialogState createState() => _AddFolderDialogState();
}

enum FolderCreationOption { empty, pasteJson }

class _AddFolderDialogState extends State<AddFolderDialog> {
  final _folderNameController = TextEditingController();
  FolderCreationOption _selectedOption = FolderCreationOption.empty;
  final _jsonController = TextEditingController();

  // PROMPT para generar JSON con ChatGPT:
  // "Please generate a JSON array with the following format:
  // [
  //   {
  //     "word": "apple",
  //     "translation": "manzana",
  //     "meaning": "A fruit that grows on apple trees",
  //     "note": "optional note"
  //   },
  //   ...
  // ]"
  // (Puedes ajustar el prompt según lo que necesites. Asegúrate de respetar el formato requerido.)

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Crear nuevo folder'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: _folderNameController,
              decoration: InputDecoration(
                labelText: 'Nombre del Folder',
              ),
            ),
            SizedBox(height: 16),
            Text('Selecciona una opción:'),
            ListTile(
              title: const Text('Crear folder vacío'),
              leading: Radio<FolderCreationOption>(
                value: FolderCreationOption.empty,
                groupValue: _selectedOption,
                onChanged: (FolderCreationOption? value) {
                  setState(() {
                    _selectedOption = value!;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('Agregar JSON pegado'),
              leading: Radio<FolderCreationOption>(
                value: FolderCreationOption.pasteJson,
                groupValue: _selectedOption,
                onChanged: (FolderCreationOption? value) {
                  setState(() {
                    _selectedOption = value!;
                  });
                },
              ),
            ),
            if (_selectedOption == FolderCreationOption.pasteJson)
              TextField(
                controller: _jsonController,
                decoration: InputDecoration(
                  labelText: 'Pega el JSON aquí',
                ),
                maxLines: 5,
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
            if (_folderNameController.text.trim().isEmpty) {
              return;
            }
            Folder newFolder =
                Folder(name: _folderNameController.text.trim());
            List<VocabularyItem> vocabItems = [];
            if (_selectedOption == FolderCreationOption.pasteJson) {
              try {
                List<dynamic> jsonList = json.decode(_jsonController.text);
                vocabItems = jsonList
                    .map<VocabularyItem>((item) => VocabularyItem(
                          folderId: 0, // Se actualizará después de crear el folder.
                          word: item['word'] ?? '',
                          translation: item['translation'] ?? '',
                          meaning: item['meaning'] ?? '',
                          note: item['note'] ?? '',
                        ))
                    .toList();
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('JSON inválido')));
                return;
              }
            }
            Navigator.pop(
              context,
              FolderWithVocabulary(
                  folder: newFolder, vocabularyItems: vocabItems),
            );
          },
          child: Text('Guardar'),
        ),
      ],
    );
  }
}
