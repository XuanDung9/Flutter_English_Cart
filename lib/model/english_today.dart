class EnglishToday {
  String? id;
  String? noun;
  String? quote;
  bool? isFavorite;
  EnglishToday({this.id, this.noun, this.quote, this.isFavorite = false});

  Map<String, dynamic> toJson() {
    return {'id': id, 'noun': noun, 'quote': quote, 'isFavorite': isFavorite};
  }

  // Chuyển đổi từ JSON sang EnglishToday object
  factory EnglishToday.fromJson(Map<String, dynamic> json) {
    return EnglishToday(
      id: json['id'],
      noun: json['noun'],
      quote: json['quote'],
      isFavorite: json['isFavorite'] ?? false,
    );
  }
}
