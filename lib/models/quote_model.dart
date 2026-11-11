class QuoteModel {
  final int id;
  final String quote;
  final String author;

  const QuoteModel({
    required this.id,
    required this.quote,
    required this.author,
  });

  factory QuoteModel.fromJson(Map<String, dynamic> json) {
    return QuoteModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      quote: json['quote']?.toString() ?? '',
      author: json['author']?.toString() ?? 'Unknown',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'quote': quote, 'author': author};
  }
}
