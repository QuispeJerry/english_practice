class VocabularyItem {
  int? id;
  int folderId;
  final String word;
  String translation;
  String meaning;
  String note;

  VocabularyItem({
    this.id,
    required this.folderId,
    required this.word,
    required this.translation,
    required this.meaning,
    required this.note,
  });

  factory VocabularyItem.fromMap(Map<String, dynamic> json) => VocabularyItem(
    id: json['id'],
    folderId: json['folderId'],
    word: json['word'],
    translation: json['translation'],
    meaning: json['meaning'],
    note: json['note'] ?? '',
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'folderId': folderId,
    'word': word,
    'translation': translation,
    'meaning': meaning,
    'note': note,
  };

  VocabularyItem copyWith({
    int? id,
    int? folderId,
    String? word,
    String? translation,
    String? meaning,
    String? note,
  }) {
    return VocabularyItem(
      id: id ?? this.id,
      folderId: folderId ?? this.folderId,
      word: word ?? this.word,
      translation: translation ?? this.translation,
      meaning: meaning ?? this.meaning,
      note: note ?? this.note,
    );
  }
}
