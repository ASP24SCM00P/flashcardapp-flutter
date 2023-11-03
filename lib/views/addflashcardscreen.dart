import 'package:flutter/material.dart';
import 'package:mp3/utils/db_helper.dart';

class AddFlashcardScreen extends StatefulWidget {
  final int deckId;

  AddFlashcardScreen({required this.deckId});

  @override
  _AddFlashcardScreenState createState() => _AddFlashcardScreenState();
}

class _AddFlashcardScreenState extends State<AddFlashcardScreen> {
  final TextEditingController questionController = TextEditingController();
  final TextEditingController answerController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Flashcard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: questionController,
              decoration: InputDecoration(labelText: 'Question'),
            ),
            TextField(
              controller: answerController,
              decoration: InputDecoration(labelText: 'Answer'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final question = questionController.text;
                final answer = answerController.text;

                if (question.isNotEmpty && answer.isNotEmpty) {
                  DBHelper().insertFlashcard(question, answer, widget.deckId); // Use widget.deckId
                  Navigator.of(context).pop(); // Return to the previous screen
                } else {
                  // Show an error message or validation feedback.
                }
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    questionController.dispose();
    answerController.dispose();
    super.dispose();
  }
}
