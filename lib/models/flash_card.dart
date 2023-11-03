class Flashcard {
  int id;
  String question;
  String answer;
  int deckId;

  Flashcard({
    required this.id,
    required this.question,
    required this.answer,
    required this.deckId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'question': question,
      'answer': answer,
      'deckId': deckId,
    };
  }

  factory Flashcard.fromMap(Map<String, dynamic> map) {
    return Flashcard(
      id: map['id'],
      question: map['question'],
      answer: map['answer'],
       deckId: map['deckId'] ?? 0,
    );
  }

  factory Flashcard.fromJson(Map<String, dynamic> json) {
    return Flashcard(
      id: json['id'] as int? ?? -1,
      question: json['question'] as String,
      answer: json['answer'] as String,
      deckId: json['deckId'] as int? ?? -1,
    );
  }
}