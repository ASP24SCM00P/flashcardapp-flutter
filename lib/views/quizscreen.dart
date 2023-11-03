import 'package:flutter/material.dart';
import 'package:mp3/models/flash_card.dart';
import 'package:mp3/utils/db_helper.dart';

class QuizScreen extends StatefulWidget {
  final int deckId;

  QuizScreen({required this.deckId});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<Flashcard> flashcards = [];
  int currentIndex = 0;
  bool showingAnswer = false;
  int viewedCardCount = 0;
  int viewedAnswerCount = 0;
  Set<int> viewedAnswerSet = {};
  String? deckTitle;
   Set<int> viewedCards = Set();

  @override
  void initState() {
    super.initState();
    _fetchDeckTitle();
    fetchAndShuffleFlashcards();
  }

  Future<void> _fetchDeckTitle() async {
    final title = await DBHelper().fetchDeckTitle(widget.deckId);
    setState(() {
      deckTitle = title;
    });
  }


  void fetchAndShuffleFlashcards() async {
    final fetchedFlashcards = await DBHelper().fetchCardsForDeck(widget.deckId);
    if (fetchedFlashcards.isNotEmpty) {
      setState(() {
        flashcards = List.from(fetchedFlashcards)..shuffle();
      });
    }
  }

  void showNextCard() {
  if (currentIndex < flashcards.length - 1) {
    setState(() {
      currentIndex++;
      showingAnswer = false;
     if (!viewedCards.contains(currentIndex)) {
          viewedCardCount++;
          viewedCards.add(currentIndex);
        }
    });
  } else {
   
    setState(() {
      currentIndex = 0;
      showingAnswer = false;
    });
  }
}

void showPreviousCard() {
  if (currentIndex > 0) {
    setState(() {
      currentIndex--;
      showingAnswer = false;
      if (!viewedCards.contains(currentIndex)) {
          viewedCardCount++;
          viewedCards.add(currentIndex);
        }
    });
  } else {
   
    setState(() {
      currentIndex = flashcards.length - 1;
      showingAnswer = false;
      if (!viewedCards.contains(currentIndex)) {
          viewedCardCount++;
          viewedCards.add(currentIndex);
        }
    });
  }
}




  Set<int> viewedAnswers = Set();

  void toggleAnswerVisibility() {
    setState(() {
      if (!showingAnswer) {
        if (!viewedAnswers.contains(currentIndex)) {
          viewedAnswerCount++;
          viewedAnswers.add(currentIndex);
          print("viewed answer $viewedAnswerCount");
        }
      }
      showingAnswer = !showingAnswer;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
        child: Text(deckTitle != null ? '$deckTitle Quiz' : 'Quiz'),
        ),
      ),
      body: flashcards.isEmpty
          ? Center(child: Text('No cards in this deck.'))
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Card ${currentIndex + 1} of ${flashcards.length}',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 20),
                FlashcardCard(
                  flashcard: flashcards[currentIndex],
                  showingAnswer: showingAnswer,
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: showPreviousCard,
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: Icon(Icons.arrow_back), 
                      ),
                    ),
                    GestureDetector(
                      onTap: toggleAnswerVisibility,
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: Icon(
                          showingAnswer
                              ? Icons.flip_to_front
                              : Icons.flip_to_back,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: showNextCard,
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: Icon(Icons.arrow_forward), 
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text('Seen $viewedCardCount of ${flashcards.length} cards'),
                Text(
                    'Peeked at $viewedAnswerCount of $viewedCardCount answers'),
              ],
            ),
    );
  }
}

class FlashcardCard extends StatelessWidget {
  final Flashcard flashcard;
  final bool showingAnswer;

  FlashcardCard({
    required this.flashcard,
    required this.showingAnswer,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 300,
            maxHeight: 300,
          ),
          child: InkWell(
            child: Center(
              child: Text(
                showingAnswer ? flashcard.answer : flashcard.question,
              ),
            ),
          ),
        ),
        color: showingAnswer ? Colors.green[100] : Colors.purple[100], // Change color for the answer side
      ),
    );
  }
}
