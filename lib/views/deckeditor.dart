import 'package:flutter/material.dart';
import 'package:mp3/utils/db_helper.dart';

class DeckEditor extends StatefulWidget {
  final int deckId;
  final void Function() reloadDecks; 

  DeckEditor({required this.deckId,required this.reloadDecks, Key? key});

  @override
  _DeckEditorState createState() => _DeckEditorState();
}

class _DeckEditorState extends State<DeckEditor> {
  final TextEditingController _titleController = TextEditingController();
  String currentTitle = "Your Current Title";

  @override
  void initState() {
    super.initState();

    DBHelper dbHelper = DBHelper();

    dbHelper.fetchDeckTitle(widget.deckId).then((title) {
      setState(() {
        currentTitle = title;
        _titleController.text = currentTitle;
        print(currentTitle);
        print(title);
      });
    });
  }

  void saveDeckChanges() async {
    DBHelper dbHelper = DBHelper();
    print("in here");
    print(currentTitle);
    await dbHelper.updateDeck(widget.deckId, currentTitle);

    // Update the current title immediately
    setState(() {
      currentTitle = _titleController.text;
    });

    Navigator.pop(context);
  }

  void deleteDeck() async {
    DBHelper dbHelper = DBHelper();
    await dbHelper.deleteDeck(widget.deckId);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Deck'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.all(16.0),
              child: Text(
                'Deck Name',
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(16.0),
              child: TextField(
                controller: _titleController,
                onChanged: (newTitle) {
                  setState(() {
                    currentTitle = newTitle;
                  });
                },
                decoration: InputDecoration(
                  filled: false,
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
              ),
            ),
            Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    TextButton(
      onPressed: () {
        saveDeckChanges();
        widget.reloadDecks();
      },
      child: Text('Save'),
    ),
    TextButton(
      onPressed: () {
        deleteDeck();
        widget.reloadDecks();
      },
      child: Text('Delete'),
    ),
  ],
)
          ],
        ),
      ),
    );
  }
}
