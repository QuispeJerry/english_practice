import 'package:flutter/material.dart';
import 'package:practice_english/models/VocabularyItem.dart';

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
    _translationController = TextEditingController(text: widget.item.translation);
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
