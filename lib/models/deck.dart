import 'package:mp3/models/flash_card.dart';

class Deck {
  int id;
  String title;
  List<Flashcard> flashcards;

  Deck({
    required this.id,
    required this.title,
    required this.flashcards,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
    };
  }

  factory Deck.fromMap(Map<String, dynamic> map) {
    return Deck(
      id: map['id'],
      title: map['title'],
      flashcards: [],
    );
  }

   factory Deck.fromJson(dynamic json) {
    final title = json['title'] as String;
    final flashcardsList = json['flashcards'] as List;

    final flashcards = flashcardsList
        .map((flashcardJson) => Flashcard.fromJson(flashcardJson))
        .toList();

    return Deck(
      title: title,
      flashcards: flashcards,
      id: 0,
    );
  }

}
