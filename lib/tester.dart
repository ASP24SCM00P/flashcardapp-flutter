import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

void printDecksAndFlashcards(Database db) async {
  // Query decks from the database
  final decks = await db.query('decks');

  print('Decks:');
  for (final deck in decks) {
    print('Deck ID: ${deck['id']}, Title: ${deck['title']}');
  }

  // Query flashcards from the database
  final flashcards = await db.query('flashcards');

  print('Flashcards:');
  for (final flashcard in flashcards) {
    print('Flashcard ID: ${flashcard['id']}, Question: ${flashcard['question']}, Answer: ${flashcard['answer']}, Deck ID: ${flashcard['deck_id']}');
  }
}


