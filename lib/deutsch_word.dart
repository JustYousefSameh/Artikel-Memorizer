const String tableWords = 'Lektoin12';

class DeutschWordFields {
  static final List<String> values = [id, artikel, word];

  static const String id = '_id';
  static const String artikel = 'Artikel';
  static const String word = 'Word';
}

class DeutschWord {
  final int? id;
  final String artikel;
  final String word;

  const DeutschWord(
    this.id,
    this.artikel,
    this.word,
  );

  DeutschWord copy(int? id, String? artikel, String? word) {
    return DeutschWord(
      id ?? this.id,
      artikel ?? this.artikel,
      word ?? this.artikel,
    );
  }

  Map<String, Object?> toJson() => {
        DeutschWordFields.id: id,
        DeutschWordFields.artikel: artikel,
        DeutschWordFields.word: word,
      };

  static DeutschWord fromJson(Map<String, Object?> json) {
    return DeutschWord(
        json[DeutschWordFields.id] as int?,
        json[DeutschWordFields.artikel] as String,
        json[DeutschWordFields.word] as String);
  }
}
