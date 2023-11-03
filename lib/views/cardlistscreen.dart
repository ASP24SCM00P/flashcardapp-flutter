import 'package:flutter/material.dart';
import 'package:mp3/models/flash_card.dart'; // Import your Flashcard model
import 'package:mp3/utils/db_helper.dart';
import 'package:mp3/views/addflashcardscreen.dart';
import 'package:mp3/views/flashcardeditor.dart';
import 'package:mp3/views/quizscreen.dart';

class CardListScreen extends StatefulWidget {
  final int deckId;

  CardListScreen({required this.deckId});

  @override
  _CardListScreenState createState() => _CardListScreenState();
}

class _CardListScreenState extends State<CardListScreen> {
  late Future<List<Flashcard>> cards;
  String? deckTitle;
   List<Flashcard>? cardList; 

  bool sortAlphabetically = false;
  @override
  void initState() {
    super.initState();
    _fetchDeckTitle();
    _loadCards();
    cards = DBHelper().fetchCardsForDeck(widget.deckId);
    cardList = [];
  }
Future<void> _fetchDeckTitle() async {
  final title = await DBHelper().fetchDeckTitle(widget.deckId);
  setState(() {
    deckTitle = title;
  });
}

Future<void> _loadCards() async {
  final dbHelper = DBHelper();
  final loadedCards = await dbHelper.fetchCardsForDeck(widget.deckId); 
  setState(() {
    cardList = loadedCards;
  });
}


void reloadCards() {
  _loadCards();
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
        child: Text('${deckTitle ?? ''} Deck'),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              sortAlphabetically ? Icons.access_time : Icons.sort_by_alpha,
            ),
            onPressed: () {
              setState(() {
                sortAlphabetically = !sortAlphabetically;
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.arrow_forward),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QuizScreen(
                      deckId: widget.deckId), // Pass the selected deck's ID
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Flashcard>>(
        future: cards,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No cards in this deck.'));
          } else {
            List<Flashcard> cardList = snapshot.data!;
            if (sortAlphabetically) {
              cardList.sort((a, b) =>
                  a.question.toLowerCase().compareTo(b.question.toLowerCase()));
            } else {
              cardList.sort((a, b) => a.id.compareTo(b.id));
            }

            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, 
                childAspectRatio: 1.0,
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final card = snapshot.data![index];
                return Padding(
                  padding: EdgeInsets.all(8.0), 

                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    color: Colors.purple[100],
                    child: InkWell(
                      onTap: () {
                    
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EditFlashcardScreen(flashcard: card, reloadCards: reloadCards),
                          ),
                        ).then((result) {
                          if (result != null) {
                           
                            setState(() {
                             
                              int index = cardList
                                  .indexWhere((card) => card.id == result.id);
                              if (index != -1) {
                                cardList[index] = result;
                              }
                              cards = DBHelper().fetchCardsForDeck(widget.deckId);
                            });
                          }
                        });
                      },
                      child: Center(
                        child: Text(card.question),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return AddFlashcardScreen(deckId: widget.deckId);
              },
            ),
          );
          setState(() {
            
            cards = DBHelper().fetchCardsForDeck(widget.deckId);
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
