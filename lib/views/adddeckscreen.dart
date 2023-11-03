import 'package:flutter/material.dart';
import 'package:mp3/utils/db_helper.dart';

class AddDeckScreen extends StatefulWidget {

   final void Function() reloadDecks; // Define the callback function

  AddDeckScreen({required this.reloadDecks, Key? key}) : super(key: key);
  @override
  _AddDeckScreenState createState() => _AddDeckScreenState();
}

class _AddDeckScreenState extends State<AddDeckScreen> {
  final TextEditingController titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Deck'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Deck Title'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final title = titleController.text;

                if (title.isNotEmpty) {
                  DBHelper().insertDeck(title);
                  Navigator.of(context).pop(); 
                  widget.reloadDecks();// Return to the previous screen
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
    titleController.dispose();
    super.dispose();
  }
}
