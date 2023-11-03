import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mp3/models/deck.dart';
import 'package:mp3/utils/db_helper.dart';
import 'package:mp3/views/adddeckscreen.dart';
import 'package:mp3/views/cardlistscreen.dart';
import 'package:mp3/views/deckeditor.dart';

class DeckList extends StatefulWidget {
  const DeckList({Key? key});

  @override
  _DeckListState createState() => _DeckListState();
}

class _DeckListState extends State<DeckList> {
  late List<Deck> decks = [];

  @override
  void initState() {
    super.initState();
    _loadDecks();
  }

  Future<void> _loadDecks() async {
    final dbHelper = DBHelper();
    final loadedDecks = await dbHelper.getDecks();
    setState(() {
      decks = loadedDecks.map((row) => Deck(
        id: row['id'] as int,
        title: row['title'] as String,
        flashcards: [], 
      )).toList();
    });
  }

void reloadDecks() {
  _loadDecks();
}


 Future<void> downloadData(BuildContext context) async {
  try {
    print("in this");
    final jsonString = await rootBundle.loadString('assets/flashcards.json');
    final jsonData = json.decode(jsonString) as List?;

    if (jsonData != null) {
      final dbHelper = DBHelper();
   

      for (var jsonDeck in jsonData) {
        if (jsonDeck is Map) {
          final Deck deck = Deck.fromJson(jsonDeck);
          final deckId = await dbHelper.insertDeck(deck.title);

          for (var flashcard in deck.flashcards) {
            await dbHelper.insertFlashcard(
              flashcard.question,
              flashcard.answer,
              deckId,
            );
          }
        }
      }

      _loadDecks(); 
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Data downloaded and processed.'),
      ));
    } else {
      print('JSON data is not in the expected format.');
    }
  } catch (e) {
    print('Error while processing data: $e');
  }
}




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Decks'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.download),
            onPressed: () async {
              print("here");
              await downloadData(context);
              
            },
          ),
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(4),
        children: decks.map((deck) {
          return Card(
            color: Colors.purple[100],
            child: Container(
              alignment: Alignment.center,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CardListScreen(deckId: deck.id),
                    ),
                  );
                },
                child: Stack(
                  children: [
                    Center(child: Text(deck.title)),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DeckEditor(deckId: deck.id, reloadDecks: reloadDecks),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newDeckId = await Navigator.of(context).push<int>(
            MaterialPageRoute(
              builder: (context) => AddDeckScreen(reloadDecks: reloadDecks),
            ),
          );
          if (newDeckId != null) {
            print("here");
            _loadDecks();
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
