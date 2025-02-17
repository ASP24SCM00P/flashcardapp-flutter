import 'package:flutter/material.dart';
import 'package:mp3/models/flash_card.dart';
import 'package:mp3/utils/db_helper.dart';

class EditFlashcardScreen extends StatefulWidget {
  final Flashcard flashcard;
  final void Function() reloadCards;

  EditFlashcardScreen({required this.flashcard, required this.reloadCards, Key? key});

  @override
  _EditFlashcardScreenState createState() => _EditFlashcardScreenState();
}

class _EditFlashcardScreenState extends State<EditFlashcardScreen> {
  String editedQuestion = '';
  String editedAnswer = '';

  @override
  void initState() {
    super.initState();
    editedQuestion = widget.flashcard.question;
    editedAnswer = widget.flashcard.answer;
  }

  void saveChanges() async {
    DBHelper dbHelper = DBHelper();
    await dbHelper.updateFlashcard(
      widget.flashcard.id, 
      editedQuestion,       
      editedAnswer          
    );
    Navigator.pop(context, widget.flashcard);
  }

  void deleteFlashcard() async {
  DBHelper dbHelper = DBHelper();
  await dbHelper.deleteFlashcard(widget.flashcard.id);
widget.reloadCards();
  
  Navigator.pop(context, true);
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
  appBar: AppBar(
    title: Text('Edit Flashcard'),
  ),
  body: Center(
    child: Container( 
      margin: EdgeInsets.all(16.0), 
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Question',
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
              ),
              TextFormField(
                initialValue: editedQuestion,
                onChanged: (value) {
                  setState(() {
                    editedQuestion = value;
                  });
                },
              ),
            ],
          ),
          SizedBox(height: 10),
          Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Answer",
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
              ),
              TextFormField(
                initialValue: editedAnswer,
                onChanged: (value) {
                  setState(() {
                    editedAnswer = value;
                  });
                },
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                saveChanges();
                widget.reloadCards();
                },
                child: Text('Save'),
              ),
              TextButton(
                onPressed: () {
                deleteFlashcard();
                widget.reloadCards();
                } ,
                child: Text('Delete'),
              ),
            ],
          ),
        ],
      ),
    ),
  ),
);
}
}