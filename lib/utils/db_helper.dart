import 'package:mp3/models/flash_card.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static const String _databaseName = 'flashcards.db';
  static const int _databaseVersion = 1;

  DBHelper._(); // private constructor (can't be called from outside)

  static final DBHelper _singleton = DBHelper._();

  factory DBHelper() => _singleton;

  Database? _database;

  get db async {
    _database ??= await _initDatabase();
    return _database;
  }

  Future<Database> _initDatabase() async {
    var dbDir = await getApplicationDocumentsDirectory();
    var dbPath = path.join(dbDir.path, _databaseName);


    var db = await openDatabase(
      dbPath,
      version: _databaseVersion,
      onCreate: (Database db, int version) async {
        await _createDecksTable(db);
        await _createFlashcardsTable(db);
      },
    );

    return db;
  }

  Future<void> _createDecksTable(Database db) async {
    await db.execute('''
      CREATE TABLE decks(
        id INTEGER PRIMARY KEY,
        title TEXT
      )
    ''');
  }

  Future<void> _createFlashcardsTable(Database db) async {
    await db.execute('''
      CREATE TABLE flashcards(
        id INTEGER PRIMARY KEY,
        question TEXT,
        answer TEXT,
        deck_id INTEGER,
        FOREIGN KEY (deck_id) REFERENCES decks(id)
      )
    ''');
  }

  
  // CRUD operations for decks
  Future<int> insertDeck(String title) async {
    final db = await this.db;
    return db.insert('decks', {'title': title});
  }

  Future<int> updateDeck(int id, String title) async {
    final db = await this.db;
    return db.update('decks', {'title': title}, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteDeck(int id) async {
    final db = await this.db;
    await db.delete('decks', where: 'id = ?', whereArgs: [id]);
    await db.delete('flashcards', where: 'deck_id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> getDecks() async {
    final db = await this.db;
    return db.query('decks');
  }

  Future<int> insertFlashcard(String question, String answer, int deckId) async {
  final db = await this.db;
  final card = {
    'question': question,
    'answer': answer,
    'deck_id': deckId,
  };

  final cardId = await db.insert('flashcards', card);
  print('Inserted card with ID: $cardId');
  return cardId;
}


  Future<int> updateFlashcard(int id, String question, String answer) async {
    final db = await this.db;
    return db.update('flashcards', {'question': question, 'answer': answer}, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteFlashcard(int id) async {
    final db = await this.db;
    await db.delete('flashcards', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> getFlashcards(int deckId) async {
    final db = await this.db;
    return db.query('flashcards', where: 'deck_id = ?', whereArgs: [deckId]);
  }

  // Retrieving decks with associated flashcards
  Future<List<Map<String, dynamic>>> getDeckWithFlashcards(int deckId) async {
    final db = await this.db;
    return db.rawQuery('''
      SELECT decks.id AS deck_id, decks.title, flashcards.id AS flashcard_id, flashcards.question, flashcards.answer
      FROM decks
      LEFT JOIN flashcards ON decks.id = flashcards.deck_id
      WHERE decks.id = ?
    ''', [deckId]);
  }

  Future<String> fetchDeckTitle(int deckId) async {
  final db = await this.db;
  var res = await db.query('decks', where: 'id = ?', whereArgs: [deckId]);
  if (res.isNotEmpty) {
    return res.first['title'];
  }
  return 'Deck Title'; 
}

Future<List<Flashcard>> fetchCardsForDeck(int deckId) async {
  final db = await this.db; 
  final cards = await db.query(
    'flashcards', 
    where: 'deck_id = ?',
    whereArgs: [deckId],
  );

  // Print the query and results for debugging
  print('Fetching cards for deck $deckId');
  print('SQL Query: SELECT * FROM flashcards WHERE deck_id = $deckId');
  print('Found ${cards.length} cards for deck $deckId');

  // Convert the query result to a list of Flashcard instances
  return List.generate(cards.length, (index) {
    return Flashcard.fromMap(cards[index]);
  });
}
}


