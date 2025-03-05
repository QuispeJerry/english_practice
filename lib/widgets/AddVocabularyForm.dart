import 'package:flutter/material.dart';
import 'package:practice_english/models/VocabularyItem.dart';

class AddVocabularyForm extends StatefulWidget {
  final int folderId;
  const AddVocabularyForm({required this.folderId});

  @override
  _AddVocabularyFormState createState() => _AddVocabularyFormState();
}

class _AddVocabularyFormState extends State<AddVocabularyForm> {
  final _wordController = TextEditingController();
  final _translationController = TextEditingController();
  final _meaningController = TextEditingController();
  final _noteController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _wordController,
              decoration: InputDecoration(
                labelText: 'Palabra en inglés',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingresa una palabra';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _translationController,
              decoration: InputDecoration(
                labelText: 'Traducción',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingresa una traducción';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _meaningController,
              decoration: InputDecoration(
                labelText: 'Significado',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingresa un significado';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _noteController,
              decoration: InputDecoration(
                labelText: 'Nota (opcional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancelar'),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final newItem = VocabularyItem(
                        folderId: widget.folderId,
                        word: _wordController.text,
                        translation: _translationController.text,
                        meaning: _meaningController.text,
                        note: _noteController.text,
                      );
                      Navigator.pop(context, newItem);
                    }
                  },
                  child: Text('Guardar'),
                ),
              ],
            ),
          ],
        ),
      ),
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
