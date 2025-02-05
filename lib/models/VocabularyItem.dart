class VocabularyItem {
  final String word;
  String translation;
  String meaning;
  String note;

  VocabularyItem({
    required this.word,
    required this.translation,
    required this.meaning,
    required this.note,
  });

  factory VocabularyItem.fromJson(Map<String, dynamic> json) {
    return VocabularyItem(
      word: json['word'],
      translation: json['translation'],
      meaning: json['meaning'],
      note: json['note'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'word': word,
    'translation': translation,
    'meaning': meaning,
    'note': note,
  };

  VocabularyItem copyWith({
    String? word,
    String? translation,
    String? meaning,
    String? note,
  }) {
    return VocabularyItem(
      word: word ?? this.word,
      translation: translation ?? this.translation,
      meaning: meaning ?? this.meaning,
      note: note ?? this.note,
    );
  }
}
