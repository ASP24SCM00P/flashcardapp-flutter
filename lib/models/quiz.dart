import 'package:mp3/models/flash_card.dart';

class Quiz {
  List<Flashcard> flashcards;
  int currentCardIndex;
  bool answerVisible;

  Quiz({
    required this.flashcards,
    this.currentCardIndex = 0,
    this.answerVisible = false,
  });

  void shuffleCards() {
    flashcards.shuffle();
  }

  Flashcard getCurrentCard() {
    return flashcards[currentCardIndex];
  }

  void nextCard() {
    if (currentCardIndex < flashcards.length - 1) {
      currentCardIndex++;
      answerVisible = false;
    }
  }

  void previousCard() {
    if (currentCardIndex > 0) {
      currentCardIndex--;
      answerVisible = false;
    }
  }

  void toggleAnswerVisibility() {
    answerVisible = !answerVisible;
  }
}